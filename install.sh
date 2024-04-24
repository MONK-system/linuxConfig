#!/bin/bash

echo "Starting script..."

echo "Running the packages script..."
# Runs the packages script
$HOME/linuxConfig/packages.sh

echo "Creating ~/.config directory..."
mkdir -p $HOME/.config

echo "Cloning and configuring DWM..."
# Installs and configures DWM
git clone https://git.suckless.org/dwm $HOME/.config/dwm
cp $HOME/linuxConfig/config.h $HOME/.config/dwm
cd $HOME/.config/dwm
make clean install

echo "Appending content to /etc/apparmor.d/usr.bin.surf..."
# Append content to /etc/apparmor.d/usr.bin.surf
cat $HOME/linuxConfig/usr.bin.surf | sudo tee -a /etc/apparmor.d/usr.bin.surf >/dev/null

echo "Setting up Samba File Share"
# Setting up Samba File Share
sudo mkdir -p /samba_share
sudo cp $HOME/linuxConfig/smb.conf /etc/samba/smb.conf
sudo groupadd smbshare
sudo chgrp -R smbshare /samba_share
sudo chmod 2770 /samba_share
sudo usermod -aG smbshare $USER
sudo smbpasswd -a $USER
sudo smbpasswd -e $USER
sudo systemctl restart nmbd

echo "Reloading AppArmor profile..."
# Reload AppArmor profile
sudo apparmor_parser -r /etc/apparmor.d/usr.bin.surf

echo "Moving .xinitrc file..."
# Move .xinitrc file
mv $HOME/linuxConfig/.xinitrc $HOME/

echo "Appending content to ~/.profile..."
# Append content to ~/.profile
cat $HOME/linuxConfig/.profile >>$HOME/.profile

mv $HOME/linuxConfig/monkserver /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/monkserver /etc/nginx/sites-enabled/
sudo systemctl restart nginx

echo "Cloning and setting up MONK system..."
# Cloning and setting up MONK system
git clone https://github.com/MONK-system/system $HOME/system

echo "Switching to the 'dev' branch in the system repository..."
cd $HOME/system
git checkout lib

echo "Fixing permissions for database"
# Fix permissions for database
chmod 660 $HOME/system/monksystem/db.sqlite3
chmod 775 $HOME/system/monksystem/nihon_kohden_files/
chmod 775 $HOME/system/monksystem/
chown $USER:$USER $HOME/system/monksystem/db.sqlite3
chown $USER:$USER $HOME/system/monksystem/nihon_kohden_files/
chown $USER:$USER $HOME/system/monksystem/

echo "Creating virtual environment and installing gunicorn..."
# Creating virtual environment and installing gunicorn
virtualenv $HOME/monkenv
source $HOME/monkenv/bin/activate
pip install gunicorn django plotly numpy pandas git+https://github.com/MONK-system/library.git

echo "Script completed. Restart to run MonkSystem"
#source $HOME/.profile
