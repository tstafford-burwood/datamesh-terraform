#! /bin/bash

# ADD VERBOSITY TO SCRIPT OUTPUT
set -v

# DEFINE USER AS `USERNAME_DOMAIN`
USER=username_domain

# TEMPORARILY ADD USER FOR INITIAL CONFIGURATION
# OS LOGIN WILL CREATE USER ENTRIES IN getent passwd AND getent group FROM A GOOGLE MANAGED LDAP
useradd $USER

# CREATE HOME DIRECTORY FOR USER IN JAIL
mkdir -p /home/jail/home/$USER
chown $USER:$USER /home/jail/home/$USER

# CREATE .ssh/ DIRECTORY IN USER'S CHROOT HOME DIRECTORY
# SET PERMISSIONS TO .ssh/ DIRECTORY
mkdir -p /home/jail/home/$USER/.ssh
chmod 700 /home/jail/home/$USER/.ssh

# CREATE known_hosts FILE IN USERS .ssh/ DIRECTORY
# SET known_hosts PERMISSIONS
touch /home/jail/home/$USER/.ssh/known_hosts
chmod 644 /home/jail/home/$USER/.ssh/known_hosts

# DELETE TEMPORARY USER PROFILE
userdel $USER