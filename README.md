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

# Vagrant Setup
There is a Vagrant box for the system, which you can install with the following steps:
1. Clone the repo
2. [Install Virtualbox](https://www.virtualbox.org/wiki/Downloads) and [Install Vagrant](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant#linux)
3. Navigate to the repository, and run 
```
      vagrant box add monk package.box
```
4.Initialize the Vagrant Environment with 
```
      vagrant init monk
```
5. Replace the content in the Vagrantfile with the Vagrantfile from the repo.
6. Start the VM by running:
```
      vagrant up
```
7. Now you can access the box in Virtualbox

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
    
