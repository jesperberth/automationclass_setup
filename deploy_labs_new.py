import csv
import subprocess
import logging
from pathlib import Path
import sys
import time

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

def launch_container(username: str, password: str) -> bool:
    """
    Launch two Docker containers sequentially with provided credentials
    Returns True if both containers succeed, False otherwise
    """
    try:
        # Validate inputs
        if not username or not password:
            raise ValueError("Username and password cannot be empty")

        # Path validation
        credentials_path = Path('/home/jesper/.azure/credentials')
        if not credentials_path.exists():
            raise FileNotFoundError(f"Credentials file not found at {credentials_path}")

        # First container configuration
        first_container_command = [
            'docker',
            'run',
            '-d',
            '--mount',
            f'type=bind,source={credentials_path},target=/root/.azure/credentials',
            '-e', f'username={username}',
            '-e', f'password={password}',
            'ansiblenewclass:latest'
        ]

        # Launch first container
        first_result = subprocess.run(
            first_container_command,
            text=True,
            capture_output=True,
            check=False
        )

        if first_result.returncode != 0:
            logging.error(f"First container launch failed for user {username}. Error: {first_result.stderr}")
            return False

        first_container_id = first_result.stdout.strip()
        logging.info(f"Launched first container for user {username}. Container ID: {first_container_id}")

        # Wait for first container to complete
        if not wait_for_container(first_container_id):
            logging.error(f"First container failed or timed out for user {username}")
            return False

        # Second container configuration
        second_container_command = [
            'docker',
            'run',
            '-d',
            '--mount',
            f'type=bind,source={credentials_path},target=/root/.azure/credentials',
            '-e', f'username={username}',
            '-e', f'password={password}',
            'ansiblenewclassstudent:latest'  # Using a different image for the second container
        ]

        # Launch second container
        second_result = subprocess.run(
            second_container_command,
            text=True,
            capture_output=True,
            check=False
        )

        if second_result.returncode != 0:
            logging.error(f"Second container launch failed for user {username}. Error: {second_result.stderr}")
            return False

        second_container_id = second_result.stdout.strip()
        logging.info(f"Successfully launched second container for user {username}. Container ID: {second_container_id}")
        
        # Optionally wait for second container to complete as well
        if not wait_for_container(second_container_id):
            logging.error(f"Second container failed or timed out for user {username}")
            return False

        return True

    except (subprocess.SubprocessError, ValueError, FileNotFoundError) as e:
        logging.error(f"Error launching containers for user {username}: {str(e)}")
        return False

def read_csv(filepath: str) -> None:
    """Read user credentials from CSV and launch containers"""
    try:
        filepath = Path(filepath)
        if not filepath.exists():
            raise FileNotFoundError(f"CSV file not found: {filepath}")

        successful_launches = 0
        failed_launches = 0

        with open(filepath, mode='r', newline='') as file:
            reader = csv.DictReader(file)

            # Validate CSV structure
            required_fields = {'Username', 'Password'}
            if not required_fields.issubset(reader.fieldnames):
                raise ValueError(f"CSV must contain fields: {required_fields}")

            for row in reader:
                if launch_container(row['Username'], row['Password']):
                    successful_launches += 1
                else:
                    failed_launches += 1

        logging.info(f"Deployment complete. Successful: {successful_launches}, Failed: {failed_launches}")

    except (csv.Error, FileNotFoundError, ValueError) as e:
        logging.error(f"Error processing CSV file: {str(e)}")
        sys.exit(1)

def main():
    setup_logging()
    logging.info("Starting deployment")
    read_csv('users.csv')

if __name__ == "__main__":
    main()