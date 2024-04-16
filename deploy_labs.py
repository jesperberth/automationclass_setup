import csv
import subprocess

def launchContainer(username, password):
    usernameCmd = f"username={username}"
    passwordCmd = f"password={password}"
    command = ['docker','run', '-d', '--mount', 'type=bind,source=/home/jesper/.azure/credentials,target=/root/.azure/credentials', '-e', usernameCmd, '-e', passwordCmd, 'automationclass:latest']
    result = subprocess.run(command, text=True, capture_output=True)

    print("Return code:", result.returncode)
    print("Output:", result.stdout)

def readCSV():
    with open('users.csv', mode='r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            username = row['Username']
            password = row['Password']
            launchContainer(username, password)

def main():
    print("Start deployment")
    readCSV()

if __name__ == "__main__":
    main()
