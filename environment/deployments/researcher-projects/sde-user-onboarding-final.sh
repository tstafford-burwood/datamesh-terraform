#! /bin/bash

# ADD VERBOSITY TO SCRIPT OUTPUT
set -v

# RUN THIS SCRIPT AFTER THE USER HAS LOGGED INTO THE BASTION VM

# DEFINE USER AS `USERNAME_DOMAIN`
USER=rkoliyatt3_prorelativity_com

# RESTART OS LOGIN CACHE SERVICE
# USERS HAVE POSIX INFORMATION UPDATED AFTER LOGGING IN AND THIS IS STORED IN A LDAP
# BELOW COMMANDS FOR passwd AND group NEED THIS SERVICE RESTARTED
systemctl restart google-oslogin-cache.service

# COPY passwd AND group LDAP ENTRIES INTO CHROOT
# NEEDED FOR UID TO MATCH USER AFTER THEY LOG IN TO CHROOT HOME DIRECTORY
getent passwd > /home/jail/etc/passwd
getent group > /home/jail/etc/group

# SET PERMISSIONS ON passwd FILE IN JAIL FOR UID TO BE OBTAINED FOR SSH
chmod 644 /home/jail/etc/passwd

# CREATE .bash_profile IN USER'S CHROOT HOME DIRECTORY
# APPEND PATH FOR /bin IN CHROOT
touch /home/jail/home/$USER/.bash_profile
echo "PATH=/bin" > /home/jail/home/$USER/.bash_profile

# CHOWN HOME DIRECTORY FOR USER
# SET PERMISSIONS ON USER HOME DIRECTORY
chown -R $USER:$USER /home/jail/home/$USER
chmod -R 700 /home/jail/home/$USER