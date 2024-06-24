# Exit immediately if a command exits with a non-zero status
set -e

# Determine the OS and set the environment variable
if [ -f /etc/debian_version ]; then
    export DISTRO="debian"
    echo "Debian-based OS detected"
elif [ -f /etc/lsb-release ]; then
    export DISTRO="ubuntu"
    echo "Ubuntu-based OS detected"
else
    echo "Unsupported OS"
    exit 1
fi

# Needed for all installers
sudo apt update -y
sudo apt install -y curl git unzip

# Needed for debian installers
if [ "$DISTRO" == "debian" ]; then
        sudo apt install -y snapd
fi

# Ensure computer doesn't go to sleep or lock while installing
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 0

# Run installers
for script in ~/.local/share/omakub/install/*.sh; do source $script; done

# Upgrade everything that might ask for a reboot last
sudo apt upgrade -y

# Revert to normal idle and lock settings
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.session idle-delay 300

# Unset the DISTRO environment variable after use
unset DISTRO

# Logout to pickup changes
gum confirm "Ready to logout for all settings to take effect?" && gnome-session-quit --logout --no-prompt
