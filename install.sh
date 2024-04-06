#!/bin/bash

# Checks if script is running as root
if [ "$(id -u)" -ne 0 ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

# Runs the packages script
./linuxConfig/packages.sh

mkdir ~/.config

# Installs and configures DWM
git clone https://git.suckless.org/dwm ~/.config/dwm
cp ~/.linuxConfig/config.h ~/.config/dwm
cd ~/.config/dwm
make clean install

# cat linuxConfig/usr.bin.surf >>/etc/apparmor.d/usr.bin.surf
# Get the content to append from linuxConfig/usr.bin.surf
content=$(cat linuxConfig/usr.bin.surf)

# Append the content after the last } in /etc/apparmor.d/usr.bin.surf
sed -i '${/}/s/$/'"$content"'/' /etc/apparmor.d/usr.bin.surf

apparmor_parser -r /etc/apparmor.d/usr.bin.surf

mv ~/linuxConfig/.xinitrc ~/

cat ~/linuxConfig/.profile >>~/.profile

git clone https://github.com/MONK-system/system ~/
