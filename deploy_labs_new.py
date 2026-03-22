import argparse
import csv
import subprocess
import logging
import threading
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
import sys
import time

MEM_CONTAINER1_MB = 2000  # ansiblenewclass:latest
MEM_CONTAINER2_MB = 300   # ansiblenewclassstudent:latest

def detect_vm_memory() -> int:
    """Detect total VM memory available to Docker, returns MB"""
    result = subprocess.run(
        ['docker', 'info', '--format', '{{json .MemTotal}}'],
        capture_output=True, text=True, check=False
    )
    if result.returncode == 0:
        try:
            return int(result.stdout.strip()) // (1024 * 1024)
        except ValueError:
            pass
    logging.warning("Could not detect VM memory, defaulting to 4096 MB")
    return 4096


def calculate_semaphore_limits(available_mb: int) -> tuple:
    """Calculate max concurrent containers of each type based on available memory"""
    max_c1 = max(1, available_mb // MEM_CONTAINER1_MB)
    max_c2 = max(1, available_mb // MEM_CONTAINER2_MB)
    logging.info(
        f"VM memory: {available_mb} MB → "
        f"max {max_c1} container-1s, {max_c2} container-2s concurrently"
    )
    return max_c1, max_c2


def setup_logging():
    """Configure logging for the application"""
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.StreamHandler(sys.stdout),
            logging.FileHandler('container_deployment.log')
        ]
    )

def wait_for_container(container_id: str, timeout: int = 1200) -> bool:
    """
    Wait for a container to complete execution
    Returns True if container completed successfully, False otherwise
    """
    try:
        start_time = time.time()
        while True:
            if time.time() - start_time > timeout:
                logging.error(f"Container {container_id} timed out after {timeout} seconds")
                return False

            result = subprocess.run(
                ['docker', 'inspect', '--format', '{{.State.Status}}', container_id],
                capture_output=True,
                text=True,
                check=False
            )

            if result.returncode != 0:
                logging.error(f"Error checking container status: {result.stderr}")
                return False

            status = result.stdout.strip()
            if status == 'exited':
                # Check exit code
                exit_code_result = subprocess.run(
                    ['docker', 'inspect', '--format', '{{.State.ExitCode}}', container_id],
                    capture_output=True,
                    text=True,
                    check=False
                )
                return exit_code_result.stdout.strip() == '0'
            
            time.sleep(5)  # Wait before checking again
            
    except subprocess.SubprocessError as e:
        logging.error(f"Error monitoring container {container_id}: {str(e)}")
        return False

def launch_container(username: str, password: str,
                     sem1: threading.Semaphore, sem2: threading.Semaphore) -> bool:
    """
    Launch two Docker containers sequentially with provided credentials.
    Semaphores gate each container type to enforce memory limits independently,
    so container 1's slot is released as soon as it finishes — allowing the next
    user's container 1 to start while container 2 is still running.
    Returns True if both containers succeed, False otherwise.
    """
    try:
        # Validate inputs
        if not username or not password:
            raise ValueError("Username and password cannot be empty")

        # Path validation
        credentials_path = Path('/Users/jesper/.azure/credentials')
        if not credentials_path.exists():
            raise FileNotFoundError(f"Credentials file not found at {credentials_path}")

        # First container — hold semaphore only while it runs
        with sem1:
            first_result = subprocess.run(
                [
                    'docker', 'run', '-d',
                    '--mount', f'type=bind,source={credentials_path},target=/root/.azure/credentials',
                    '-e', f'username={username}',
                    '-e', f'password={password}',
                    'ansiblenewclass:latest'
                ],
                text=True, capture_output=True, check=False
            )

            if first_result.returncode != 0:
                logging.error(f"First container launch failed for user {username}. Error: {first_result.stderr}")
                return False

            first_container_id = first_result.stdout.strip()
            logging.info(f"Launched first container for user {username}. Container ID: {first_container_id}")

            if not wait_for_container(first_container_id):
                logging.error(f"First container failed or timed out for user {username}")
                return False
        # sem1 released here — next user's container 1 can now start

        # Second container — hold semaphore only while it runs
        with sem2:
            second_result = subprocess.run(
                [
                    'docker', 'run', '-d',
                    '--mount', f'type=bind,source={credentials_path},target=/root/.azure/credentials',
                    '-e', f'username={username}',
                    '-e', f'password={password}',
                    'ansiblenewclassstudent:latest'
                ],
                text=True, capture_output=True, check=False
            )

            if second_result.returncode != 0:
                logging.error(f"Second container launch failed for user {username}. Error: {second_result.stderr}")
                return False

            second_container_id = second_result.stdout.strip()
            logging.info(f"Successfully launched second container for user {username}. Container ID: {second_container_id}")

            if not wait_for_container(second_container_id):
                logging.error(f"Second container failed or timed out for user {username}")
                return False

        return True

    except (subprocess.SubprocessError, ValueError, FileNotFoundError) as e:
        logging.error(f"Error launching containers for user {username}: {str(e)}")
        return False

def read_csv(filepath: str) -> None:
    """Read user credentials from CSV and launch containers in parallel"""
    try:
        filepath = Path(filepath)
        if not filepath.exists():
            raise FileNotFoundError(f"CSV file not found: {filepath}")

        with open(filepath, mode='r', newline='') as file:
            reader = csv.DictReader(file)

            # Validate CSV structure
            required_fields = {'Username', 'Password'}
            if not required_fields.issubset(reader.fieldnames):
                raise ValueError(f"CSV must contain fields: {required_fields}")

            rows = list(reader)

        available_mb = detect_vm_memory()
        max_c1, max_c2 = calculate_semaphore_limits(available_mb)
        sem1 = threading.Semaphore(max_c1)
        sem2 = threading.Semaphore(max_c2)

        successful_launches = 0
        failed_launches = 0

        with ThreadPoolExecutor(max_workers=len(rows)) as executor:
            futures = {
                executor.submit(launch_container, row['Username'], row['Password'], sem1, sem2): row['Username']
                for row in rows
            }
            for future in as_completed(futures):
                if future.result():
                    successful_launches += 1
                else:
                    failed_launches += 1

        logging.info(f"Deployment complete. Successful: {successful_launches}, Failed: {failed_launches}")

    except (csv.Error, FileNotFoundError, ValueError) as e:
        logging.error(f"Error processing CSV file: {str(e)}")
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(description='Deploy lab containers')
    parser.add_argument('--log', action='store_true', help='Enable logging to stdout and file')
    args = parser.parse_args()

    if args.log:
        setup_logging()

    logging.info("Starting deployment")
    read_csv('users.csv')

if __name__ == "__main__":
    main()