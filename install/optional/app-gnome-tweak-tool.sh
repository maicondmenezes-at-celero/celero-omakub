# Title: Gnome Tweak Tool
# Description: A tool to customize advanced GNOME 3 options

# Check linux distro

if [ "$DISTRO" == "ubuntu" ]; then
    # install for ubuntu

    sudo apt install -y gnome-tweak-tool

elif [ "$DISTRO" == "debian" ]; then
    # install for debian

    sudo apt install -y gnome-tweaks

fi