#! /bin/bash

# ADD VERBOSITY TO SCRIPT OUTPUT IN GCE VM CONSOLE LOGS
set -v

# CREATE CHROOT DIRECTORY
# SET CHROOT DIRECTORY AND SUB-DIRECTORY OWNERSHIP TO ROOT
mkdir -p /home/jail
chown root:root /home/jail
chmod 755 /home/jail


# MAKE HOME DIRECTORY IN CHROOT
mkdir -p /home/jail/home
chmod 755 /home/jail/home


# CREATE /dev FILES IN CHROOT DIRECTORY
mkdir -p /home/jail/dev
chmod 755 /home/jail/dev
mount --bind /dev /home/jail/dev


# CREATE /bin IN CHROOT
# COPY /bin/bash, /bin/ssh, /bin/ssh-agent, /bin/ssh-add
mkdir -p /home/jail/bin
chmod 755 /home/jail/bin
cp -va /bin/bash /home/jail/bin/
cp -va /bin/ssh /home/jail/bin/
cp -va /bin/ssh-agent /home/jail/bin/
cp -va /bin/ssh-add /home/jail/bin/


# CREATE /lib64 IN CHROOT
mkdir -p /home/jail/lib64
chmod -R 755 /home/jail/lib64

# CREATE ID IN CHROOT
mkdir /home/jail/usr
chmod 755 /home/jail/usr

mkdir /home/jail/usr/bin
chmod 755 /home/jail/usr/bin

cp -va /usr/bin/id /home/jail/usr/bin
cp /usr/bin/id /home/jail/usr/bin
chmod 755 /home/jail/usr/bin/id

# GATHER SHARED OBJECTS AND SHARED LIBRARIES FOR /bin/bash
# ldd /bin/bash
# COPY SHARED OBJECTS/LIBRARIES TO CHROOT /lib64
cp -v /lib64/{libtinfo.so.6,libdl.so.2,libc.so.6,ld-linux-x86-64.so.2} /home/jail/lib64/
cp -v /lib64/{libcrypto.so.1.1,libutil.so.1,libz.so.1,libcrypt.so.1,libresolv.so.2,libselinux.so.1,libgssapi_krb5.so.2,libkrb5.so.3,libk5crypto.so.3,libcom_err.so.2,libpthread.so.0,libpcre2-8.so.0,libkrb5support.so.0,libkeyutils.so.1} /home/jail/lib64/

# COPY libnss_* TO JAIL FOR UID MATCHING
cp -va /lib64/libnss_* /home/jail/lib64/

chmod -R 755 /home/jail/lib64


# CREATE /etc DIRECTORY IN CHROOT
mkdir -p /home/jail/etc
chmod 755 /home/jail/etc

# COPY nsswitch.conf TO JAIL FOR UID MATCHING
cp -va /etc/nsswitch.conf /home/jail/etc/


# CREATE /usr/share/terminfo DIRECTORY IN JAIL
mkdir -p /home/jail/usr/share/terminfo

# COPY terminfo TO JAIL FOR CHROOT CLI FUNCTIONALITY
cp -rva /usr/share/terminfo/* /home/jail/usr/share/terminfo/

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
printf "%s\n\t" 'Match User "*,!username_domain"' 'ChrootDirectory /home/jail' >> /etc/ssh/sshd_config

# RESTART SSHD SERVICE
systemctl restart sshd