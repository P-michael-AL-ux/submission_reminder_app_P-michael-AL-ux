
Submissions Reminder Application
This repository contains the shell scripts and README needed to run the Submissions Reminder application.
Files in the Repository
create_environment.sh – Sets up the directory structure and necessary files for the application.


copilot_shell_script.sh – Main script to check assignments and trigger reminders.


README.md – Instructions for setting up and using the app.



Instructions to Run the Application
Step 1: Ensure the Scripts Are Executable
Check the file permissions using:
ls -l copilot_shell_script.sh
ls -l create_environment.sh

If the files are executable, you are ready.


If not, update the permissions:


chmod u+x create_environment.sh
chmod u+x copilot_shell_script.sh


Step 2: Run create_environment.sh to Set Up the App
Run the script to create the directories and files:


./create_environment.sh
# or
sh create_environment.sh
# or
bash create_environment.sh

When prompted, enter your name. This will be used as the main directory name, e.g., submission_reminder_John.


Wait for the script to complete creating all files and directories.


Verify the directory structure using:


tree submission_reminder_<yourname>

Expected output:
submission_reminder_<yourname>
├── app
│   └── reminder.sh
├── assets
│   └── submissions.txt
├── config
│   └── config.env
├── modules
│   └── functions.sh
└── startup.sh


Step 3: Run copilot_shell_script.sh
Run the script:


./copilot_shell_script.sh
# or
sh copilot_shell_script.sh
# or
bash copilot_shell_script.sh

Follow the prompts:


Enter the last name of your directory if multiple directories exist.


Select the assignment name you want to check.


The script will:
Update the ASSIGNMENT variable in config/config.env.


Execute startup.sh, which runs the reminder.sh script in the app directory.



Overview of Each Script
create_environment.sh
Creates the main directory and subdirectories (app, modules, assets, config).


Creates all necessary files (reminder.sh, functions.sh, submissions.txt, config.env, startup.sh).


Makes .sh files executable.


copilot_shell_script.sh
Allows the user to select and check assignments.


Updates the assignment in the config file.


Executes startup.sh to trigger the reminder system.





