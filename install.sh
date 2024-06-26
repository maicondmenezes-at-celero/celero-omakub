# Load display functions
source ~/.local/share/omakub/display.sh

# Initialize variables
total_scripts=$(ls ~/.local/share/omakub/install/*.sh | wc -l)
executed_scripts=0
start_time=$(date +%s)

# Function to record the line number and script that caused an error
function handle_error {
    local lineno="$1"
    local script="$2"
    local error_message

    # Get the error message
    error_message=$(cat /tmp/error_message)

    display_footer
    echo "Error on or near line $lineno executing: $script"
    echo "Error message: $error_message"
    echo "Press any key to exit..."
    read -n 1 -s
    exit 1
}

# Set the error handler
trap 'handle_error $LINENO "$current_script"' ERR

# Set debug handler to catch the current command
trap 'current_command=$BASH_COMMAND' DEBUG

# Redirect all errors to /tmp/error_message
exec 2> /tmp/error_message

# Set the current script name to current_script
current_script="${BASH_SOURCE[0]}"

# Display the header
display_header

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
    executed_scripts=$((executed_scripts + 1))
    displaay_progress1
    source $script;
done

# Upgrade everything that might ask for a reboot last
sudo apt upgrade -y

# Revert to normal idle and lock settings
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.session idle-delay 300

# Unset the DISTRO environment variable after use
unset DISTRO

# Unset error redirection
exec 2>&1


# Logout to pickup changes
gum confirm "Ready to logout for all settings to take effect?" && gnome-session-quit --logout --no-prompt

exit 0