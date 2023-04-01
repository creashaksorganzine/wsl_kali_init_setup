#!/bin/bash

This script is used to setup a new Kali Linux subsystem for Windows 11 installation
Update the system
sudo apt update && sudo apt install aptitude -y
if [ $? -eq 0 ]; then
sudo aptitude update && sudo aptitude full-upgrade -y
if [ $? -eq 0 ]; then
echo "System update and upgrade completed successfully."
else
echo "Error: System upgrade failed."
fi
else
echo "Error: System update failed."
fi

Modify .bashrc to change history settings
echo "export HISTSIZE=10000" >> ~/.bashrc
echo "export HISTFILESIZE=20000" >> ~/.bashrc
if [ $? -eq 0 ]; then
echo "bashrc modification completed successfully."
source ~/.bashrc
else
echo "Error: bashrc modification failed."
exit 1
fi

Check if bash-completion is installed
dpkg -s bash-completion > /dev/null
if [ $? -eq 0 ]; then
echo "bash-completion is already installed."
else
echo "bash-completion is not installed. Installing now..."

Install bash-completion
sudo apt install bash-completion -y
if [ $? -eq 0 ]; then
echo "bash-completion installation completed successfully."
else
echo "Error: bash-completion installation failed."
exit 1
fi
fi

Install Kali Linux CLI tools
sudo aptitude install -y kali-linux-headless

Ask user if they want to install a GUI environment and tools
read -p "Do you want to install a GUI environment and tools (y/n)? " gui

if [ "$gui" == "y" ]; then
# Update the system
sudo apt update && sudo apt upgrade -y

# Install common tools
sudo apt install -y build-essential git vim htop curl wget zip unzip net-tools tcpdump nmap

# Prompt the user to install a desktop environment
read -p "Do you want to install a desktop environment (y/n)? " desktop
if [ "$desktop" == "y" ]; then
    sudo apt install -y xfce4 xfce4-goodies
fi

# Prompt the user to install an RDP or VNC server
read -p "Do you want to install an RDP or VNC server (y/n)? " remote
if [ "$remote" == "y" ]; then
    read -p "Which server do you want to install (RDP/VNC)? " server
    if [ "$server" == "RDP" ]; then
        sudo apt install -y xrdp
    elif [ "$server" == "VNC" ]; then
        sudo apt install -y tightvncserver
    else
        echo "Invalid input. Please enter either RDP or VNC."
    fi
fi

# Exit the script with success message
echo "Kali Linux subsystem GUI setup completed successfully."
exit 0
