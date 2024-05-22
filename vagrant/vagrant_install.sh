#!/bin/bash

echo "Starting script..."

# Update package list and install necessary packages with --force-yes
sudo apt-get update
sudo apt-get install -y --force-yes git make nginx samba virtualenv apparmor-utils expect

echo "Switched to the Vagrant user..."
sudo -u vagrant -H sh <<'EOF'
echo "Cloning linuxConfig repository..."

# Install git to clone the repository
git clone https://github.com/MONK-system/linuxConfig ~/linuxConfig/

echo "Running the packages script..."
# Runs the packages script and automatically provides "Y" response to prompts
yes | ~/linuxConfig/scripts/packages.sh

echo "Creating ~/.config directory..."
mkdir -p ~/.config

echo "Cloning and configuring DWM..."
# Installs and configures DWM
git clone https://git.suckless.org/dwm ~/.config/dwm
cp ~/linuxConfig/config/config.h ~/.config/dwm
cd ~/.config/dwm
sudo make clean install

EOF

echo "Appending content to /etc/apparmor.d/usr.bin.surf..."
sudo bash -c 'cat /home/vagrant/linuxConfig/config/usr.bin.surf > /etc/apparmor.d/usr.bin.surf'

echo "Setting up Samba File Share"
sudo mkdir -p /samba_share
sudo bash -c 'cat /home/vagrant/linuxConfig/config/smb.conf >> /etc/samba/smb.conf'
sudo groupadd smbshare
sudo chgrp -R smbshare /samba_share
sudo chmod 2770 /samba_share

# Use expect to automatically provide the Samba password
sudo expect <<EOD
spawn sudo smbpasswd -a vagrant
expect "New SMB password:"
send "123\r"
expect "Retype new SMB password:"
send "123\r"
expect eof
EOD

sudo systemctl restart smbd

echo "Reloading AppArmor profile..."
sudo apparmor_parser -r /etc/apparmor.d/usr.bin.surf

echo "Moving .xinitrc file..."
sudo mv /home/vagrant/linuxConfig/config/.xinitrc /home/vagrant/

echo "Appending content to ~/.profile..."
sudo bash -c 'cat /home/vagrant/linuxConfig/config/.profile >> /home/vagrant/.profile'

sudo mv /home/vagrant/linuxConfig/config/monkserver /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/monkserver /etc/nginx/sites-enabled/
sudo systemctl restart nginx

echo "Cloning and setting up MONK system..."
sudo -u vagrant -H sh <<'EOF'
git clone https://github.com/MONK-system/system ~/system
cd ~/system
git checkout main

echo "Fixing permissions for database"
sudo chmod 775 ~/system/monksystem/
sudo chown $USER:$USER ~/system/monksystem/

echo "Creating virtual environment and installing gunicorn..."
virtualenv ~/system/monkenv
source ~/system/monkenv/bin/activate
~/system/monkenv/bin/pip install gunicorn django plotly numpy pandas git+https://github.com/MONK-system/library.git
~/system/monkenv/bin/python3 ~/system/monksystem/manage.py migrate

echo "Script completed. Restart to run MonkSystem"
EOF
