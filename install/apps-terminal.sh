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
