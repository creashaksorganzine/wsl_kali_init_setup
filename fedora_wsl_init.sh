#!/usr/bin/env bash

# Update the system
if sudo dnf update -y; then
    printf "\nSystem updated successfully.\n"
else
    printf "\nError: Failed to update the system.\n"
    exit 1
fi

# Install basic tools
if sudo dnf install -y vim htop curl wget zip unzip net-tools tcpdump nmap; then
    printf "\nBasic tools installed successfully.\n"
else
    printf "\nError: Failed to install basic tools.\n"
    exit 1
fi

# Install development tools and libraries
if sudo dnf groupinstall -y "Development Tools" && sudo dnf install -y kernel-devel kernel-headers dkms; then
    printf "\nDevelopment tools and libraries installed successfully.\n"
else
    printf "\nError: Failed to install development tools and libraries.\n"
    exit 1
fi

# Install common codecs and plugins
if sudo dnf install -y ffmpeg gstreamer1-plugins-base gstreamer1-plugins-good gstreamer1-plugins-bad-free gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly; then
    printf "\nCommon codecs and plugins installed successfully.\n"
else
    printf "\nError: Failed to install common codecs and plugins.\n"
    exit 1
fi

# Modify .bashrc to change history settings
if echo "export HISTSIZE=10000" >> ~/.bashrc && echo "export HISTFILESIZE=20000" >> ~/.bashrc; then
    printf "\nbashrc modified successfully.\n"
    source ~/.bashrc
else
    printf "\nError: Failed to modify bashrc.\n"
    exit 1
fi

# Check if bash-completion is installed
if rpm -q bash-completion > /dev/null; then
    printf "\nbash-completion is already installed.\n"
else
    printf "\nInstalling bash-completion...\n"
    if sudo dnf install bash-completion -y; then
        printf "\nbash-completion installed successfully.\n"
    else
        printf "\nError: Failed to install bash-completion.\n"
        exit 1
    fi
fi

# Ask user if they want to install a GUI environment and tools
read -p "Do you want to install a GUI environment and tools (y/n)? " gui

if [ "$gui" == "y" ]; then
    # Update the system
    if sudo dnf update -y; then
        printf "\nSystem updated successfully.\n"
    else
        printf "\nError: Failed to update the system.\n"
    exit 1
fi

# Install common tools
if sudo dnf install -y build-essential git vim htop curl wget zip unzip net-tools tcpdump nmap; then
    printf "\nCommon tools installed successfully.\n"
else
    printf "\nError: Failed to install common tools.\n"
    exit 1
fi

# Prompt the user to install a desktop environment
read -p "Do you want to install a desktop environment (y/n)? " desktop
if [ "$desktop" == "y" ]; then
    if sudo dnf groupinstall -y gnome-desktop && sudo systemctl set-default graphical.target; then
        printf "\nDesktop environment installed successfully.\n"
    else
        printf "\nError: Failed to install desktop environment.\n"
        exit 1
    fi
fi

# Prompt the user to install an RDP or VNC server
read -p "Do you want to install an RDP or VNC server (y/n)? " remote
if [ "$remote" == "y" ]; then
    read -p "Which server do you want to install (RDP/VNC)? " server
    if [ "$server" == "RDP" ]; then
        if sudo dnf install -y xrdp; then
            printf "\nRDP server installed successfully.\n"
        else
            printf "\nError: Failed to install RDP server.\n"
            exit 1
        fi
    elif [ "$server" == "VNC" ]; then
        if sudo dnf install -y tigervnc-server; then
            printf "\nVNC server installed successfully.\n"
        else
            printf "\nError: Failed to install VNC server.\n"
            exit 1
        fi
    else
        printf "\nError: Invalid input. Please enter either RDP or VNC.\n"
        exit 1
    fi
fi

# Exit the script with success message
printf "\nFedora Linux subsystem GUI setup completed successfully.\n"
exit 0
