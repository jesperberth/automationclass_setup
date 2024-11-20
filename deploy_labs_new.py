import csv
import subprocess
import logging
from pathlib import Path
import sys

def setup_logging():
    """Configure logging for the application"""
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.StreamHandler(sys.stdout),
            logging.FileHandler('~/container_deployment.log')
        ]
    )

def launch_container(username: str, password: str) -> bool:
    """
    Launch a Docker container with provided credentials
    Returns True if successful, False otherwise
    """
    try:
        # Validate inputs
        if not username or not password:
            raise ValueError("Username and password cannot be empty")

        # Path validation
        credentials_path = Path('/home/jesper/.azure/credentials')
        if not credentials_path.exists():
            raise FileNotFoundError(f"Credentials file not found at {credentials_path}")

        command = [
            'docker',
            'run',
            '-d',
            '--mount',
            f'type=bind,source={credentials_path},target=/root/.azure/credentials',
            '-e', f'username={username}',
            '-e', f'password={password}',
            'ansiblenewclass:latest'
        ]

        result = subprocess.run(
            command,
            text=True,
            capture_output=True,
            check=False  # Don't raise exception, we'll handle it
        )

        if result.returncode != 0:
            logging.error(f"Container launch failed for user {username}. Error: {result.stderr}")
            return False

        logging.info(f"Successfully launched container for user {username}. Container ID: {result.stdout.strip()}")
        return True

    except (subprocess.SubprocessError, ValueError, FileNotFoundError) as e:
        logging.error(f"Error launching container for user {username}: {str(e)}")
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