#!/bin/bash


# Global variables
username="";
password="";


# Checks if the script is run as root
function Exit_If_Not_Root() {
    if [ "$EUID" -ne 0 ]; then 
        echo "Please run this script as root"
        exit
    fi
}

# Checks if the current user is the one that was created for installation
function Exit_If_Wrong_User() {
	currentUser=$(whoami)
	if [ $currentUser != $username ]; then
		echo "Wrong user! Script must be executed by the user $username"
		exit
	fi
}

# Checks if you have access to internet (checks Google DNS availability)
function Has_Internet_Connection() {
	nc -z 8.8.8.8 53  > /dev/null 2>&1
	online=$?
	if [ $online -eq 0 ]; then
	    echo "Awesome! This machine has internet connection!"
	    return 1
	else
	    echo "This machine is Offline."
	    return 0
	fi
}

# Prints out the message and waits
function Print_Message_And_Sleep() {
    echo $1
    sleep $2 # wait for X seconds before the next command is executed
}

# Prepare user for installation
function Prepare_System_For_Installation() {
	Print_Message_And_Sleep "Create the user that will be used for Unreal Tournament 2000 server" 1s

	echo -n "Enter the username (default: unreal): "
	read username
	username=${username:-unreal}

	echo -n "Enter the password (default: TheCakeIsALie!9999): "
	read -s password
	password=${password:-TheCakeIsALie!9999}

	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "User $username already exists!"
		exit
	fi

	sudo adduser $username --gecos "Unreal, , , " --disabled-password # Add the specified user with all the details
	#echo "$password" | passwd "$username" --stdin
	echo $username:$password | sudo chpasswd
}


if Has_Internet_Connection -eq 1; then
	Print_Message_And_Sleep "Fix your internet connection issues and rerun the script!" 5s
	exit;
fi
Exit_If_Not_Root Print_Message_And_Sleep "Matej's Unreal Tournament 2000 Server script has started" 2s
Prepare_System_For_Installation
Print_Message_And_Sleep "Preparation finished! Continuing with the installation by executing the script named 1_ut_2000_download_and_install.sh." 2s
export -f Print_Message_And_Sleep
export -f Has_Internet_Connection
export username
#export password
currentDir=$(pwd)
/bin/su -m -c "source $currentDir/1_ut_2000_download_and_install.sh" - $username
exit

# To delete the user and it's home directory run this command: sudo userdel -f -r unreal
# This works for newly created user, and in example above we used the username "unreal"
# Use this command with caution