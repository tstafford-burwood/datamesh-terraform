#! /bin/bash

# ADD VERBOSITY TO SCRIPT OUTPUT IN GCE VM CONSOLE LOGS
set -v

# CREATE CHROOT DIRECTORY
mkdir -p /home/jail

# MAKE HOME DIRECTORY IN CHROOT
mkdir -p /home/jail/home

# DETERMINE /dev NODES FOR FOLLOWING STEP
# ls -l /dev/{null,zero,stdin,stdout,stderr,random,tty}

# CREATE /dev FILES IN CHROOT DIRECTORY
mkdir -p /home/jail/dev
cd /home/jail/dev
mknod -m 666 null c 1 3
mknod -m 666 random c 1 8
mknod -m 666 tty c 5 0
mknod -m 666 zero c 1 5

# SET CHROOT DIRECTORY AND SUB-DIRECTORY OWNERSHIP TO ROOT
chown root:root /home/jail
chmod 0755 /home/jail

# CREATE /bin IN CHROOT
# COPY /bin/bash, /bin/ssh, /bin/ssh-agent, /bin/ssh-add
mkdir -p /home/jail/bin
cp -v /bin/bash /home/jail/bin/
cp -v /bin/ssh /home/jail/bin/
cp -v /bin/ssh-agent /home/jail/bin/
cp -v /bin/ssh-add /home/jail/bin/

# CREATE /lib64 IN CHROOT
mkdir -p /home/jail/lib64

# GATHER SHARED OBJECTS AND SHARED LIBRARIES FOR /bin/bash
# ldd /bin/bash
# COPY SHARED OBJECTS/LIBRARIES TO CHROOT /lib64
cp -v /lib64/{libtinfo.so.6,libdl.so.2,libc.so.6,ld-linux-x86-64.so.2} /home/jail/lib64/

# GATHER SHARED OBJECTS AND SHARED LIBRARIES FOR /bin/ssh
# ldd /bin/ssh
# COPY SHARED OBJECTS/LIBRARIES TO CHROOT /lib64
cp -v /lib64/{libcrypto.so.1.1,libutil.so.1,libz.so.1,libcrypt.so.1,libresolv.so.2,libselinux.so.1,libgssapi_krb5.so.2,libkrb5.so.3,libk5crypto.so.3,libcom_err.so.2,libpthread.so.0,libpcre2-8.so.0,libkrb5support.so.0,libkeyutils.so.1} /home/jail/lib64/

# GATHER SHARED OBJECTS AND SHARED LIBRARIES FOR /bin/ssh-agent
# ldd /bin/ssh-agent
# SHARED OBJECTS/LIBRARIES ARE DUPLICATED FROM ABOVE ldd COMMANDS

# GATHER SHARED OBJECTS AND SHARED LIBRARIES FOR /bin/ssh-add
# ldd /bin/ssh-add
# SHARED OBJECTS/LIBRARIES ARE THE EXACT SAME FROM ldd /bin/ssh-agent

# REMOVED DUPLICATE ENTRIES FROM ldd COMMAND ABOVE

# CREATE /etc DIRECTORY IN CHROOT
mkdir -p /home/jail/etc

# COPY nsswitch.conf TO JAIL FOR UID MATCHING
cp /etc/nsswitch.conf /home/jail/etc/

# COPY libnss_* TO JAIL FOR UID MATCHING
cp /lib64/libnss_* /home/jail/lib64/

# CREATE /usr/share/terminfo DIRECTORY IN JAIL
mkdir -p /home/jail/usr/share/terminfo

# COPY terminfo TO JAIL FOR CHROOT CLI FUNCTIONALITY
cp -r /usr/share/terminfo/* /home/jail/usr/share/terminfo/

# MAKE /tmp DIRECTORY IN CHROOT FOR SSH-AGENT TO FUNCTION
mkdir -p /home/jail/tmp

# EDIT PERMISSIONS ON /tmp IN CHROOT FOR SSH-AGENT TO FUNCTION
chmod 1777 /home/jail/tmp

# REMOVE EXAMPLE CODE FROM /etc/ssh/sshd_config DUE TO DUPLICATE X11FORWARDING TEXT
# EDIT /etc/ssh/sshd_config TO DISABLE TCP FORWARDING AND X11 FORWARDING
#sed -i '/Example of/Q' /etc/ssh/sshd_config
sed -i '/^AllowTcpForwarding/c\AllowTcpForwarding no' /etc/ssh/sshd_config
sed -i '/^X11Forwarding/c\X11Forwarding no' /etc/ssh/sshd_config

# APPEND CHROOT MATCH AND DIRECTORY PATH FOR ALL USERS WITH EXCEPTIONS
printf "%s\n\t" 'Match User "*,!astrong_prorelativity_com"' 'ChrootDirectory /home/jail' >> /etc/ssh/sshd_config

# RESTART SSHD SERVICE
systemctl restart sshd