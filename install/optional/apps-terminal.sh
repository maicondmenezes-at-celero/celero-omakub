# Title: Applications for Terminal
# Description: fzf: A command-line fuzzy finder
# Description: ripgrep: A line-oriented search tool
# Description: eza: A modern replacement for 'ls'
# Description: bat: A cat clone with syntax highlighting
# Description: zoxide: A smarter cd command
# Description: plocate: A faster locate command
# Description: btop: A resource monitor
# Description: apache2-utils: Apache utility programs
# Description: fd-find: A simple, fast and user-friendly alternative to find

# Check linux distro
if [ "$DISTRO" == "ubuntu" ]; then
    sudo apt install -y fzf ripgrep eza bat zoxide plocate btop apache2-utils fd-find

elif [ "$DISTRO" == "debian" ]; then
    sudo apt install -y fzf ripgrep bat zoxide plocate btop apache2-utils fd-find

    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
fi
