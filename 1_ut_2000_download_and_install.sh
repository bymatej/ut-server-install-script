#!/bin/bash


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

# Create directory structure for installation
function Create_Directories_For_Installation() {
	Print_Message_And_Sleep "Creating directory structure..." 0s
	cd /home/$username
	mkdir ut2000
	cd ut2000
}

if Has_Internet_Connection -eq 1; then
	Print_Message_And_Sleep "Fix your internet connection issues and rerun the script!" 5s
	exit;
fi
Create_Directories_For_Installation
Download_And_Install_Server
# todo: delete archive files after instalation
Print_Message_And_Sleep "Matej's Unreal Tournament 2000 Server script has finished successfully!" 1s
Print_Message_And_Sleep "Login as $username user and go to ~/ut2000/ut-server/ directory and run the ASU using the ./asu.sh command and configure your server" 5s
exit