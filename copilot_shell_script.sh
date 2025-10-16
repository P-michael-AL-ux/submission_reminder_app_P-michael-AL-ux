#!/bin/bash
#seting a variable to the main directory.
#srd stands for source directory

srd=(./submission_reminder_*)

#The Logic!!
#Lets say the user had executed creat_environment.sh more than once, hence creating many files starting with same submission_reminder_*name.
#When ever the the user executes the  copilot_shell_script.sh,he/she recives an error that says:
#"too many arguments" or binary 
#To solve this, we will Use a loop to find all matching directories and and ask the user to enter the directory he wants.

#Here, when the script is executed and finds no directory starting with submission_reminder_*, its going to display "directory not found"
if [[ ${#srd[@]} == 0 ]]; then
  echo "$srd not found"
  exit

#If there is only one directory found that meet the criteria, then it will be used to continue with the script.
elif [[ ${#srd[@]} == 1 ]]; then
  srd="${srd[0]}"

#Incase of many directories starting with submission_reminder_* then,
#the script is going to list them and prompts the user to write the directory name from the list.
else
    echo -e "----------------------------------------------------------\n"
    echo "Multifull directories found starting with submission_reminder_* "
    echo -e "Please Select the directory you want to use from the list below.\n"
    echo -e "----------------------------------------------------------\n"

    #Am using a for loop because it look into the similar directories one by one
    #listing all the directories with submission_reminder_ 
    for i in ${!srd[@]}; do
      echo "$((i+1)) ${srd[i]}"
    done
    echo -e "----------------------------------------------------------\n"
    echo 'Write the last name of the directory that you want to use.' 

#Using the infinity while loop so that the user writes the name of a directory that exists inorder to continue    
  while true; do
      echo -e "----------------------------------------------------------\n"
      read -p 'Please type last name of the directory (e.g., "John" for "submission_reminder_John"): ' yourName
      sleep 1
      if [[ -z "$yourName" ]]; then
       echo -e "----------------------------------------------------------\n"
       echo -e "\n Name can not be empty.Please try again\n"
       continue
      fi
      srd="submission_reminder_$yourName"
      if [[ -d "$srd" ]]; then
         break
      else
         echo -e "<<<<<<<<<<<<<<<<<<<<<<<<<ERROR!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
         echo 'Please type the last name as it  is on the list.'
         echo -e "----------------------------------------------------------\n"
         continue
      fi
  done 
fi
#The logic!, imagine the user doesnt know how the assignment was writen, and you need to let them know the assigments available in the list.
#So here, I want the script to list all the assignment names in the source file,
#so that the user can see the name of the assignment to use  and types it as the input.

#the following commamds will look through the source file to check all the assignments, sort them and uniq them 
# Asking  the user for assignment name that he wants to check.
while true; do
    count=1
    echo " "
    echo "Below is the list of assignments you can check:"
    echo -e "----------------------------------------------------------\n"
    awk -F, 'NR>2 {print $2}' "$srd/assets/submissions.txt" | sort | uniq | while IFS= read -r i; do
      echo "$count. $i"
      ((count++))
    done
    echo -e "----------------------------------------------------------\n"

    read -p 'Enter the new assignment name from the list above: ' assName
    echo " "
    # The file where assigment is going to be updated
    file_1="/config/config.env"

    #changing the assignment names.
    if [[ -f "$srd$file_1" ]]; then
        sed -i "s/ASSIGNMENT=\".*\"/ASSIGNMENT=\"$assName\"/" "$srd$file_1"
        echo "Successfully updated assignment to $assName"
    else
        echo "Config file not found at $srd$file_1"
        exit
    fi

    #now executing startup.sh which also executes reminder.sh in the app directory of the curent directory
    file_path="$srd/startup.sh"
    #cd "$(dirname "$file_path")"
    if [[ -f "$file_path" ]]; then
      
     bash $file_path # ./startup.sh
     echo -e "--------------------------------------------\n"
    fi
    echo -n " Do You want to check another assignment(y/n): "
    read option
    echo " "
    if [[ "$option" == "y" || "$option" == "Y" ]]; then
    continue
    fi
    if [[ "$option" == "n" || "$option" == "N" ]]; then 
    echo "Exiting..."
     break
    else
     echo -e "Invalid option please try again\n"
     exit
    fi
done
