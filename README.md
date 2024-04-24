# dwmKioskMode
Config files for running dwm in kiosk mode with surf browser

Modify the URL in .xinitrc to change website. 

# Setup for Debian network install
https://www.debian.org/CD/netinst/

UNCHECK DEBIAN DESKTOP AND GNOME DURING INSTALLATION

Make new user called "monk"

First log in as root

    apt install git sudo
    usermod -aG sudo monk
    exit
    
Login as the non-root user, and run the following commands:

    sudo git clone https://github.com/MONK-system/linuxConfig
    ./linuxConfig/install.sh
    

Then run 
    
    source ~/.profile
    
It will now auto-run every time you log into the user.

Need to add you IP under ALLOWED_HOSTS in monksystem/settings.py (Find it with "ip a")
If you get OperationalError at / no such table: django_session, run python manage.py migrate 

# Samba File Share 

For testing:
    mkdir /samba_share/testDir
    touch /samba_share/testFile.txt
    systemctl restart nmbd

    smbclient '\\localhost\private' -U user
    ls

Windows Client setup:
    Win+R
    \\<ip-from-linux-machine, get with "ip a">
    
