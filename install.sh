#!/bin/bash

echo "Starting script..."

# Checks if script is not running as root
if [ "$(id -u)" -eq 0 ]; then
	echo "This script must not be run as root" 1>&2
	exit 1
fi

echo "Running the packages script..."
# Runs the packages script
#sudo $HOME/linuxConfig/packages.sh

echo "Creating ~/.config directory..."
mkdir $HOME/.config

echo "Cloning and configuring DWM..."
# Installs and configures DWM
sudo git clone https://git.suckless.org/dwm $HOME/.config/dwm
sudo cp $HOME/linuxConfig/config.h $HOME/.config/dwm
cd $HOME/.config/dwm
sudo make clean install

echo "Appending content to /etc/apparmor.d/usr.bin.surf..."
# Append content to /etc/apparmor.d/usr.bin.surf
# content=$(cat ~/linuxConfig/usr.bin.surf)
# sed -i '${/}/s/$/'"$content"'/' /etc/apparmor.d/usr.bin.surf

echo "Reloading AppArmor profile..."
# Reload AppArmor profile
apparmor_parser -r /etc/apparmor.d/usr.bin.surf

echo "Moving .xinitrc file..."
# Move .xinitrc file
sudo mv $HOME/linuxConfig/.xinitrc $HOME/

echo "Appending content to ~/.profile..."
# Append content to ~/.profile
sudo cat $HOME/linuxConfig/.profile >>$HOME/.profile

sudo mv $HOME/linuxConfig/monkserver /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/monkserver /etc/nginx/sites-enabled/
sudo systemctl restart nginx

echo "Cloning and setting up MONK system..."
# Cloning and setting up MONK system
sudo git clone https://github.com/MONK-system/system $HOME/system

echo "Switching to the 'lib' branch in the system repository..."
cd $HOME/system
sudo git checkout lib

echo "Creating virtual environment and installing gunicorn..."
# Creating virtual environment and installing gunicorn
sudo virtualenv monkenv
sudo chown -R $USER:$USER $HOME/system/monkenv
sudo chmod -R u+w $HOME/system/monkenv

source $HOME/system/monkenv/bin/activate
pip install gunicorn
pip install django

echo "Script completed. Running MonkSystem"
source $HOME/.profile
