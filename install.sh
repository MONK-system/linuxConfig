#!/bin/bash

echo "Starting script..."

# Checks if script is not running as root
if [ "$(id -u)" -eq 0 ]; then
	echo "This script must not be run as root" 1>&2
	exit 1
fi

echo "Running the packages script..."
# Runs the packages script
#sudo /home/$USER/linuxConfig/packages.sh

echo "Creating ~/.config directory..."
mkdir ~/.config

echo "Cloning and configuring DWM..."
# Installs and configures DWM
sudo git clone https://git.suckless.org/dwm /home/$USER/.config/dwm
sudo cp /home/$USER/.linuxConfig/config.h ~/.config/dwm
cd ~/.config/dwm
sudo make clean install

echo "Appending content to /etc/apparmor.d/usr.bin.surf..."
# Append content to /etc/apparmor.d/usr.bin.surf
content=$(cat ~/linuxConfig/usr.bin.surf)
sed -i '${/}/s/$/'"$content"'/' /etc/apparmor.d/usr.bin.surf

echo "Reloading AppArmor profile..."
# Reload AppArmor profile
apparmor_parser -r /etc/apparmor.d/usr.bin.surf

echo "Moving .xinitrc file..."
# Move .xinitrc file
mv ~/linuxConfig/.xinitrc ~/

echo "Appending content to ~/.profile..."
# Append content to ~/.profile
sudo cat /home/$USER/linuxConfig/.profile >>/home/$USER/.profile

echo "Cloning and setting up MONK system..."
# Cloning and setting up MONK system
sudo git clone https://github.com/MONK-system/system /home/$USER/

echo "Switching to the 'lib' branch in the system repository..."
cd ~/system
sudo git checkout lib

echo "Creating virtual environment and installing gunicorn..."
# Creating virtual environment and installing gunicorn
virtualenv monkenv
source monkenv/bin/activate
pip install gunicorn

echo "Script completed. Running MonkSystem"
source ~/.profile
