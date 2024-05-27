# MONK Linux Configuration

# Setup for Debian network install
https://www.debian.org/CD/netinst/

Uncheck Debian desktop and GNOME during the installation

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

# Vagrant Setup
There is a Vagrant box for the system, which you can install with the following steps:
1. Clone the repo
2. [Install Virtualbox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://developer.hashicorp.com/vagrant/install?product_intent=vagrant#linux)
3. Navigate to the vagrant directory and run the following:
```
      vagrant up
```
```
7. Wait for the system to install, and you should now be able to access the box in Virtualbox

### NOTE: username: vagrant, password:vagrant, root password: vagrant

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
    
