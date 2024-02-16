# dwmKioskMode
Config files for running dwm in kiosk mode with surf browser

Modify the URL in .xinitrc to change website. Might bug out if it is a website with a lot of javascript bloat.

# Setup for Debian network install
https://www.debian.org/CD/netinst/
UNCHECK DEBIAN DESKTOP AND GNOME DURING INSTALLATION

First log in as root

    apt install vim git surf xserver-xorg-core xinit xinput x11-xserver-utils build-essentials libx11-dev libxinerama-dev libxft-dev  
    usermod -aG sudo user
    exit
    
Login as the non-root user, use sudo in front of commands that need it from now on.

# DWM build:
    mkdir .config
    cd .config
    git clone https://git.suckless.org/dwm
    cd dwm
    make clean install

# DWM configuration:
    cd ~/
    git clone https://github.com/jonafoll/dwmKioskMode

    cd dwmKioskMode
    cp config.h ~/.config/dwm

    cd ~/.config/dwm
    make clean install

# .xinitrc setup:
    cd ~/dwmKioskMode
    mv .xinitrc.txt ~/
    cd ~/
    cat .xinitrc.txt >> ~/.xinitrc

# Autostart on login
    cd ~/dwmKioskMode
    mv ~/.bash_profile.txt ~/
    cd ~/
    cat bash_profile.txt >> ~/bash_profile

# startx
When you login to the user, it should launch right into surf browser in kiosk mode.
