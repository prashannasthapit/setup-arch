#!/bin/bash
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

# Set up VMware Tools services
cd ..
cd ..
cp ./vmtoolsd.service /usr/lib/systemd/system/vmtoolsd.service
cp ./vmware-vmblock-fuse.service /usr/lib/systemd/system/vmware-vmblock-fuse.service

systemctl enable vmtoolsd.service
systemctl start vmtoolsd.service
systemctl enable vmware-vmblock-fuse.service
systemctl start vmware-vmblock-fuse.service

# Clean up
# pacman -R --noconfirm chrpath doxygen rpcsvc-proto cunit
