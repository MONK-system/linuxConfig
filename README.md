# dwmKioskMode
Config files for running dwm in kiosk mode with surf browser

Modify the URL in .xinitrc to change website. Might bug out if it is a website with a lot of javascript bloat.

# Setup for Debian network install
https://www.debian.org/CD/netinst/

UNCHECK DEBIAN DESKTOP AND GNOME DURING INSTALLATION

First log in as root

    apt install git sudo
    usermod -aG sudo user
    exit
    
Login as the non-root user, use sudo in front of commands that need it from now on.

    git clone https://github.com/MONK-system/linuxConfig
    ./linuxConfig/packages.sh

# DWM build:
    mkdir .config
    cd .config
    git clone https://git.suckless.org/dwm

# DWM configuration:
    cp linuxConfig/config.h ~/.config/dwm

    cd ~/.config/dwm
    make clean install

# .xinitrc setup:
    cd
    mv linuxConfig/.xinitrc ~/

# Autostart on login
    cd 
    cat linuxConfig/.profile >> ~/.profile

# startx
When you login to the user, it should launch right into surf browser in kiosk mode.

# Python Setup
    cd 
    git clone https://github.com/MONK-system/system
    (TEMPORARY): git checkout dev

# Samba File Share Setup
    mkdir /samba_share
    cat ~/linuxConfig/smb.conf >> /etc/samba/smb.conf

    groupadd smbshare
    chgrp -R smbshare /samba_share
    chmod 2770 /samba_share

    usermod -aG smbshare user

    smbpasswd -a user
    smbpasswd -e user

    systemctl restart nmbd

For testing:
    mkdir /samba_share/testDir
    touch /samba_share/testFile.txt
    systemctl restart nmbd

    smbclient '\\localhost\private' -U user
    ls

Windows Client setup:
    Win+R
    \\<ip-from-linux-machine, get with "ip a">
    