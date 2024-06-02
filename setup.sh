#!/bin/bash

pacman -Syu
pacman -S --noconfirm gnome firefox git base-devel xmlsec fuse2 icu iproute2 libdnet libmspack libsigc++ libxcrypt libcrypt.so libxss lsb-release procps-ng uriparser gdk-pixbuf-xlib chrpath doxygen gtkmm3 libxtst python rpcsvc-proto netctl cunit
systemctl enable gdm.service

git clone https://github.com/vmware/open-vm-tools.git
git clone https://github.com/daimaou92/install-arch-vmwarefusion-techpreview.git

# Build open-vm-tools
cd open-vm-tools/open-vm-tools
autoreconf -i
./configure --prefix=/usr --sbindir=/usr/bin --sysconfdir=/etc --with-udev-rules-dir=/usr/lib/udev/rules.d --without-xmlsecurity --without-kernel-modules
make
make check
make install
ldconfig
cd

# Set up VMware Tools services
cd /home/kami/install-arch-vmwarefusion-techpreview/after/openvmtools
cp ./vmtoolsd.service /usr/lib/systemd/system/vmtoolsd.service
cp ./vmware-vmblock-fuse.service /usr/lib/systemd/system/vmware-vmblock-fuse.service

# Enable and check vmtoolsd service
systemctl enable vmtoolsd.service
systemctl start vmtoolsd.service
if systemctl is-active --quiet vmtoolsd.service; then
    echo "vmtoolsd.service is active."
    systemctl status vmtoolsd.service
else
    echo "vmtoolsd.service is not active."
    systemctl status vmtoolsd.service
fi

# Enable and check vmware-vmblock-fuse service
systemctl enable vmware-vmblock-fuse.service
systemctl start vmware-vmblock-fuse.service
if systemctl is-active --quiet vmware-vmblock-fuse.service; then
    echo "vmware-vmblock-fuse.service is active."
    systemctl status vmware-vmblock-fuse.service
else
    echo "vmware-vmblock-fuse.service is not active."
    systemctl status vmware-vmblock-fuse.service
fi

# Clean up unnecessary packages
pacman -R --noconfirm chrpath doxygen rpcsvc-proto cunit

# Clean up cloned repositories
cd
rm -rf open-vm-tools
rm -rf /home/kami/install-arch-vmwarefusion-techpreview
