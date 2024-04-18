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
sudo su -c '
          cat /home/monk/linuxConfig/usr.bin.surf > /etc/apparmor.d/usr.bin.surf
' root

echo "Reloading AppArmor profile..."
# Reload AppArmor profile
sudo apparmor_parser -r /etc/apparmor.d/usr.bin.surf

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

echo "Fixing permissions for database"
sudo chmod 660 $HOME/system/monksystem/db.sqlite3
sudo chmod 775 $HOME/system/monksystem/nihon_kohden_files/
sudo chmod 775 $HOME/system/monksystem/

sudo chown $USER:$USER $HOME/system/monksystem/db.sqlite3
sudo chown $USER:$USER $HOME/system/monksystem/nihon_kohden_files/
sudo chown $USER:$USER $HOME/system/monksystem/

echo "Creating virtual environment and installing gunicorn..."
# Creating virtual environment and installing gunicorn
sudo virtualenv monkenv
sudo chown -R $USER:$USER $HOME/system/monkenv
sudo chmod -R u+w $HOME/system/monkenv

source $HOME/system/monkenv/bin/activate
pip install gunicorn
pip install django
pip install git+https://github.com/MONK-system/library.git

echo "Script completed. Restart to run MonkSystem"
#source $HOME/.profile
