#!/bin/bash

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root."
    exit 1
fi

echo "Updating package list..."
apt update

echo "Installing dependencies..."
apt install -y git build-essential automake autoconf pkg-config \
               libwxgtk3.0-gtk3-dev wx3.0-headers \
               libtool libssl-dev gawk \
               parted ntfs-3g

echo "Cloning WoeUSB repository..."
git clone https://github.com/WoeUSB/WoeUSB-frontend-wxgtk.git
cd WoeUSB-frontend-wxgtk || exit

echo "Building and installing WoeUSB..."
./setup-development-environment.bash
./autoreconf --force --install
./configure
make
make install

echo "Creating symbolic link for easier access..."
ln -sf /usr/local/bin/woeusbgui /usr/bin/woeusbgui
ln -sf /usr/local/bin/woeusbcmd /usr/bin/woeusbcmd

echo "Cleaning up..."
cd ..
rm -rf WoeUSB-frontend-wxgtk

echo "WoeUSB installation complete!"
echo "You can run the GUI version using 'woeusbgui' or the command line version using 'woeusbcmd'."
