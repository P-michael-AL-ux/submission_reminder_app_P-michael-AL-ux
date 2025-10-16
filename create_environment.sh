#!/bin/bash
#prompting the user for there name to use in the directory.
#In this script, i used animations using the for loop in order to make it look realistic, and fun.
echo -e "\n----------------------------------------------------------\n"
read -p "Please enter your name: " yourName
echo " "
while true; do
    if [[ -z "$yourName" ]]; then
        echo -e "Name cannot be empty.\n"
        read -p "Do you want to continue and create a name (Y/N): " option


        if [[ -z "$option" ]]; then
            echo -e "\nYour input is empty(Exiting by default)\n"
            echo -ne "Exiting"
            #animation part
            for j in {1..5}; do
                echo -n "."
                sleep 0.3
            done
            sleep 0.5
            echo -ne "\r                                                          \r"
            echo -e "\n----------------------------------------------------------\n"
            #Done with animation now exiting
            exit

        elif [[ "$option" == "y" || "$option" == "Y" ]]; then
            read -p "Enter your name: " yourName
            echo -e "\n----------------------------------------------------------\n"
            continue

        elif [[ "$option" == "n" || "$option" == "N" ]]; then
            echo -e "\n----------------------------------------------------------\n"
            echo "Exiting..."
            for j in {1..5}; do
                echo -n "."
                sleep 0.3
            done
            sleep 0.5
            echo -ne "\r                                                          \r"
            echo -e "\n----------------------------------------------------------\n"
            break

        else
            echo -e "\n----------------------------------------------------------\n"
            echo "Invalid option. Please type Y or N."
            echo -e "\n----------------------------------------------------------\n"
            continue
        fi
    else
        break
    fi
done

#creating varialbe names for the directory
main_dir="submission_reminder_$yourName"

#Checking if the directory is already present or not.
if [[ ! -d "$main_dir" && -n "$yourName"  ]]; then
   mkdir -p "$main_dir"
   echo -e "\n----------------------------------------------------------\n"
   echo -ne "Creating the directory.."
   #animation
   for j in {1..5}; do
     echo -n "."
     sleep 0.3
   done
   sleep 0.5
   echo -ne "\r                                                          \r"
   #end of animation, now creating the file using touch command

   #success massage
   echo "Directory $main_dir created succesfully"
   echo -e "\n----------------------------------------------------------\n"
elif [[ -z "$yourName" ]]; then
    exit
else
   echo -e "\n----------------------------------------------------------\n"
   echo -e "\nThe directory exist\n"
   echo -e "\n----------------------------------------------------------\n"
   echo "TREE DIAGRAM OF $main_dir"
   tree $main_dir
   echo -e "\n----------------------------------------------------------\n"
   exit
fi
#I will define a function called file_path and echo all the files paths and location  in it.
file_paths() {
echo "$main_dir/app/reminder.sh"
echo "$main_dir/modules/functions.sh"
echo "$main_dir/assets/submissions.txt"
echo "$main_dir/config/config.env"
echo "$main_dir/startup.sh"
}

#creating the main, sub directories and files 

#using the for loop to read line by line the content of the file_path function
#to make it essay to create the files
for i in $(file_paths); do
 mkdir -p $( dirname "$i" )
 echo -e "\n----------------------------------------------------------\n"
 echo -ne "Checking if the directory exist.."
 #This for loop is for animation. Just to make it look like its loading 
 for j in {1..5}; do
    echo -n "."
    sleep 0.3
 done
 sleep 0.5
 echo -ne "\r                                                          \r"
 #the echo "\r   \r" clears the whole line with the message after it has desplayed the message
 echo "Directory $i created successfully"
 echo -e "\n----------------------------------------------------------\n"
 # After checking if the main directory is created, it will proceed with creating the files if they dont exist
 if [[ ! -f "$i" ]]; then
   echo -ne "Creating the files.Please wait.."
   #animation
   for j in {1..5}; do
     echo -n "."
     sleep 0.3
   done
   sleep 0.5
   echo -ne "\r                                                          \r"
   #end of animation, now creating the file using touch command

   touch "$i"
   echo "file $i was created successfully"
   echo -ne "Checking if the file ends with *.sh.."

   #Animation 
   for j in {1..3}; do
     echo -n "."
     sleep 0.3
   done
   sleep 0.5
   echo -ne "\r                                                          \r"
   #end of animation

   #now checking if the file ends with *.sh and making the files excutable if so
   if [[ -f "$i" && "$i" == *.sh ]]; then
   #animation
   echo "                                                              "
    echo -ne " File found ending with *.sh. Making it executable.."
    for j in {1..3}; do
       echo -n "."
       sleep 0.3
    done
    sleep 0.5
    echo -ne "\r                                                                \r"
    #end of animation

    #now changing making the file executable using chmod commad
    chmod +x "$i"
    echo "File $i is now executable"
    echo -e "\n----------------------------------------------------------\n"
   fi
 else
   echo -e "----------------------------------------------------------\n" 
   echo "file already exist"
   echo -e "----------------------------------------------------------\n"
 fi
done
echo -ne "All files created succesfully   "
sleep 1
echo -e "\r                                                                 \r"
echo "Tree Diagram of $main_dir"
tree $main_dir
#now that the files are created, we need to put the contents in them.
#I will use echo to print the content on to the file 
remind_file="$main_dir/app/reminder.sh"
func_file="$main_dir/modules/functions.sh"
subm_file="$main_dir/assets/submissions.txt"
conf_file="$main_dir/config/config.env"
start="$main_dir/startup.sh"
#when we use echo and direct it into a file, it over writes any other content of the file.
#all the content where previously provided
echo '#!/bin/bash
# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
' > $remind_file
#am using echo '...' so that it will the echo also the functions as they are with out running them
echo '#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
' > $func_file

echo '# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
' > $conf_file

echo 'student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Agnes, Shell Basics, not submitted
Bol, Git, not submitted
Chol, Shell Basics, submitted
Makuei, Git, not submitted
Jack, Shell Navigation, submitted' > $subm_file

#echoing the script to execute the reminder.sh file into the startup.sh file
echo '#!/bin/bash

#Making files in reminder app executable
cd "$(dirname "$0")"

./app/reminder.sh

' > $start