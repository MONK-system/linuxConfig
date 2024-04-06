#!/bin/bash

echo "Starting script..."

# Checks if script is running as root
if [ "$(id -u)" -ne 0 ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

echo "Running the packages script..."
# Runs the packages script
./linuxConfig/packages.sh

echo "Creating ~/.config directory..."
mkdir ~/.config

echo "Cloning and configuring DWM..."
# Installs and configures DWM
git clone https://git.suckless.org/dwm ~/.config/dwm
cp ~/.linuxConfig/config.h ~/.config/dwm
cd ~/.config/dwm
make clean install

echo "Appending content to /etc/apparmor.d/usr.bin.surf..."
# Append content to /etc/apparmor.d/usr.bin.surf
content=$(cat linuxConfig/usr.bin.surf)
sed -i '${/}/s/$/'"$content"'/' /etc/apparmor.d/usr.bin.surf

echo "Reloading AppArmor profile..."
# Reload AppArmor profile
apparmor_parser -r /etc/apparmor.d/usr.bin.surf

echo "Moving .xinitrc file..."
# Move .xinitrc file
mv ~/linuxConfig/.xinitrc ~/

echo "Appending content to ~/.profile..."
# Append content to ~/.profile
cat ~/linuxConfig/.profile >>~/.profile

echo "Cloning and setting up MONK system..."
# Cloning and setting up MONK system
git clone https://github.com/MONK-system/system ~/

echo "Creating virtual environment and installing gunicorn..."
# Creating virtual environment and installing gunicorn
cd ~/system
virtualenv monkenv
source monkenv/bin/activate
pip install gunicorn

echo "Script completed. Running MonkSystem"
source ~/.profile
