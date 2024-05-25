#!/bin/bash

echo "Starting script..."

# Checks if script is not running as root
if [ "$(id -u)" -eq 0 ]; then
	echo "This script must not be run as root" >&2
	exit 1
fi

echo "Running the packages script..."
$HOME/linuxConfig/scripts/packages.sh

echo "Creating ~/.config directory..."
mkdir -p $HOME/.config

echo "Cloning and configuring DWM..."
git clone https://git.suckless.org/dwm $HOME/.config/dwm
cp $HOME/linuxConfig/config/config.h $HOME/.config/dwm
cd $HOME/.config/dwm
sudo make clean install

echo "Setting up Samba File Share as root..."
sudo su -c '
    mkdir /samba_share
    groupadd smbshare
    chgrp -R smbshare /samba_share
    chmod 2770 /samba_share
    usermod -aG smbshare $USER
    smbpasswd -a $USER
    smbpasswd -e $USER
    systemctl restart nmbd
'

echo "Appending content to /etc/apparmor.d/usr.bin.surf as root..."
sudo su -c '
    cat /home/monk/linuxConfig/config/usr.bin.surf > /etc/apparmor.d/usr.bin.surf
'

echo "Reloading AppArmor profile..."
sudo apparmor_parser -r /etc/apparmor.d/usr.bin.surf

echo "Moving .xinitrc file..."
mv $HOME/linuxConfig/config/.xinitrc $HOME/

echo "Appending content to ~/.profile..."
cat $HOME/linuxConfig/config/.profile >>$HOME/.profile

echo "Setting up Nginx configuration as root..."
sudo mv $HOME/linuxConfig/config/monkserver /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/monkserver /etc/nginx/sites-enabled/
sudo systemctl restart nginx

echo "Cloning and setting up MONK system..."
git clone https://github.com/MONK-system/system $HOME/system

echo "Switching to the 'dev' branch in the system repository..."
cd $HOME/system
git checkout main

echo "Setting permissions for MONK system..."
chmod 775 $HOME/system/monksystem/
chown $USER:$USER $HOME/system/monksystem/

echo "Creating virtual environment and installing gunicorn..."
virtualenv $HOME/system/monkenv
chown -R $USER:$USER $HOME/system/monkenv
chmod -R u+w $HOME/system/monkenv

source $HOME/system/monkenv/bin/activate
pip install gunicorn django plotly numpy pandas git+https://github.com/MONK-system/library.git
python3 $HOME/system/monksystem/manage.py migrate

echo "Script completed. Restart to run MONK-system"
