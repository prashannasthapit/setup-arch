cp ~/.config/monitors.xml ~gdm/.config/monitors.xml
chown gdm:gdm ~gdm/.config/monitors.xml
machinectl shell gdm@ /bin/bash
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"