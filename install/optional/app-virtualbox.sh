# Title: VirtualBox
# Description: A powerful x86 and AMD64/Intel64 virtualization product for enterprise as well as home use

# Check linux distro
if [ "$DISTRO" == "ubuntu" ]; then
    # Virtualbox allows you to run VMs for other flavors of Linux or even Windows
    # See https://ubuntu.com/tutorials/how-to-run-ubuntu-desktop-on-a-virtual-machine-using-virtualbox#1-overview
    # for a guide on how to run Ubuntu inside it.
    sudo apt install -y virtualbox virtualbox-ext-pack


elif [ "$DISTRO" == "debian" ]; then
    # Unninstall old version of VirtualBox
    sudo apt remove --purge -y virtualbox virtualbox-*

    # Add the VirtualBox repository and install the latest version
    sudo install -m 0755 -d /etc/apt/keyrings
    wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg --dearmor
    DIST_CODENAME=$(lsb_release -cs)
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $DIST_CODENAME contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list > /dev/null
    sudo apt update
    sudo apt install -y virtualbox-6.1

    # Download and install the VirtualBox Extension Pack
    EXT_PACK_URL="https://download.virtualbox.org/virtualbox/7.0.18/Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack"
    wget $EXT_PACK_URL -O /tmp/Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack
    sudo VBoxManage extpack install --replace /tmp/Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack
    rm /tmp/Oracle_VM_VirtualBox_Extension_Pack-7.0.18.vbox-extpack

fi

# Add user to vboxusers group
sudo usermod -aG vboxusers ${USER}
