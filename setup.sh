#!/bin/bash

cd
pacman -Syu
pacman -S --noconfirm gnome firefox git base-devel xmlsec fuse2 icu iproute2 libdnet libmspack libsigc++ libxcrypt libcrypt.so libxss lsb-release procps-ng uriparser gdk-pixbuf-xlib chrpath doxygen gtkmm3 libxtst python rpcsvc-proto netctl cunit
systemctl enable gdm.service

# open-vm-tools
git clone https://github.com/vmware/open-vm-tools.git
cd open-vm-tools/open-vm-tools
autoreconf -i
./configure --prefix=/usr --sbindir=/usr/bin --sysconfdir=/etc --with-udev-rules-dir=/usr/lib/udev/rules.d --without-xmlsecurity --without-kernel-modules
make
make check
make install
ldconfig
cd

# Set up VMware Tools services
cd setup-arch
cp ./vmtoolsd.service /usr/lib/systemd/system/vmtoolsd.service
cp ./vmware-vmblock-fuse.service /usr/lib/systemd/system/vmware-vmblock-fuse.service
cd

systemctl enable vmtoolsd.service
systemctl start vmtoolsd.service
systemctl enable vmware-vmblock-fuse.service
systemctl start vmware-vmblock-fuse.service


# Clean up
pacman -R --noconfirm chrpath doxygen rpcsvc-proto cunit
rm -rf open-vm-tools

# add user
username="kami"

sudo usermod -aG wheel $username

# Set password for the user
read -s -p "Enter password for $username: " password
echo "$username:$password" | sudo chpasswd

# Activate wheel group in sudoers
sudo sed -i '/%wheel ALL=(ALL) ALL/s/^# //' /etc/sudoers
