#!/bin/bash


# Global variables
username="";
password="";


# Checks if the script is run as root
function Exit_If_Not_Root() {
    if [ "$EUID" -ne 0 ]
        then 
        	echo "Please run this script as root"
        	exit
    fi
}

# Checks if you have access to internet (checks google.com availability)
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

# Prepare user and directory structure for installation
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
		echo "$username exists!"
		exit
	fi

	sudo adduser $username --gecos "Unreal, , , " --disabled-password # Add the specified user with all the details
	#echo "$password" | passwd "$username" --stdin
	echo $username:$password | sudo chpasswd

    #sudo -Hu $username cd /home/$username # Go to home directory
    #sudo -Hu $username mkdir ut2000 # Create installation directory
    #sudo -Hu $username cd ut2000 # Go to installation directory
}

# Downloads and installs the server ToDo: extract to one big zip file and download from only one source from own hosting
function Download_And_Install_Server() {
    wget http://ut-files.com/Entire_Server_Download/ut-server-436.tar.gz
    tar -zxf ut-server-436.tar.gz
    cd ut-server
    wget http://www.ut-files.com/Patches/UTPGPatch451LINUX.tar.tar
    tar xfj UTPGPatch451LINUX.tar.tar
    wget http://ut-files.com/Entire_Server_Download/server_scripts/asu-0.6.tar.gz
    tar -zxf asu-0.6.tar.gz
    chmod +x asu.sh
    cd System
    ln -s libSDL-1.1.so.0 libSDL-1.2.so.0
    cd ~/ut2000/ut-server
}


Exit_If_Not_Root Print_Message_And_Sleep "Matej's Unreal Tournament 2000 Server script has started" 2s
if Has_Internet_Connection -eq 1; 
	then
		Print_Message_And_Sleep "Fix your internet connection issues and rerun the script!" 5s
		exit;
fi
Prepare_System_For_Installation
Download_And_Install_Server
Print_Message_And_Sleep "Matej's Unreal Tournament 2000 Server script has finished successfully!" 1s
Print_Message_And_Sleep "Go to ~/ut2000/ut-server/ directory and run the ASU using the ./asu.sh command and configure your server" 5s
exit

# To delete the user and it's home directory run this command: sudo userdel -f -r unreal