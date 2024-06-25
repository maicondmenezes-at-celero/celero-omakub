# Function to record the line number and script that caused an error
function handle_error {
    local lineno="$1"
    local script="$2"
    local error_message

    # Get the error message
    error_message=$(tail -n 1 <<< "$BASH_COMMAND" 2>&1)

    echo "Error on or near line $lineno executing: $script"
    echo "Error message: $error_message"
    echo "Press any key to exit..."
    read -n 1 -s
    exit 1
}

# Set the error handler
trap 'handle_error $LINENO "$current_script"' ERR

# Set the current script name to current_script
current_script="${BASH_SOURCE[0]}"

# Check linux distro
if [ -f /etc/debian_version ]; then
    export DISTRO="debian"
    echo "Debian-based system detected"
elif [ -f /etc/lsb-release ]; then
    export DISTRO="ubuntu"
    echo "Ubuntu-based system detected"
else
    echo "Distro not supported"
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
for script in ~/.local/share/omakub/install/*.sh; do
    current_script=$script
    source $script;
done

# Upgrade everything that might ask for a reboot last
sudo apt upgrade -y

# Revert to normal idle and lock settings
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.session idle-delay 300

# Unset the DISTRO environment variable after use
unset DISTRO

# Logout to pickup changes
gum confirm "Pronto para sair para que todas as configurações entrem em vigor?" && gnome-session-quit --logout --no-prompt || echo "Configurações aplicadas. Saia manualmente quando estiver pronto."
