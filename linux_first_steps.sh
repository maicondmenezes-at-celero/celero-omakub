#!/bin/bash

TMP_FILE_PASSWORD=/tmp/pwd.${RANDOM}
ZENITY_POSITION="--width=400 --height=300"
alias zenity='zenity ${ZENITY_POSITION}'
shopt -s expand_aliases

# Utils
dearmor_gpg_key() {
    local input_file=$1
    local output_file=$2

    if [ -f "$output_file" ]; then
        timestamp=$(date +"%Y%m%d%H%M%S")
        backup_file="${output_file%.*}_$timestamp.${output_file##*.}"
        sudo mv "$output_file" "$backup_file"
        echo "File renamed $backup_file"
    fi
    
    sudo gpg --dearmor -o "$output_file" "$input_file"

}

get_sudo_password() {
    PASSWORD=$(zenity --password --title="Sudo authentication")
    if [ -z "$PASSWORD" ]; then
        zenity --error --text="Password missing."
        exit 1
    fi
    echo "$PASSWORD" | sudo -S true
}

download_file(){
    local link=$1
    local filepath=/tmp/${RANDOM}

    curl $link -o $filepath
    FILEPATH=$filepath
}

# Install mandatory
install_slack() {
    echo "# Installing slack"
    sudo snap install slack
    echo "10"
}

install_vscode() {
    echo "# Installing Visual Studio Code"
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    download_file https://packages.microsoft.com/keys/microsoft.asc && dearmor_gpg_key $FILEPATH /etc/apt/keyrings/packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 /etc/apt/keyrings/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo apt-get update
    sudo apt-get install -y code
    echo "20"
}

install_dev_tools() {
    echo "# Installing developer tools"
    sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
        libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git-all apt-transport-https \
         ca-certificates gnupg curl python3-pip pipx
    pipx install poetry
    pipx ensurepath
    echo "30"
}

install_gcloud() {
    echo "# Installing Google Cloud CLI"
    download_file https://packages.cloud.google.com/apt/doc/apt-key.gpg && dearmor_gpg_key $FILEPATH /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt-get update
    sudo apt-get install -y google-cloud-cli
    sudo apt-get install -y google-cloud-cli-skaffold
    echo "40"
}

install_kubectl() {
    echo "# Installing kubectl"
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 234654DA9A296436
    download_file https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key && dearmor_gpg_key $FILEPATH /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
    echo "50"
}

install_docker() {
    echo "# Installing docker"
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    echo "60"
}

# Install non-mandatory
install_chrome() {
    echo "# Installing Google Chrome"
    sudo apt-get install -y libnss3
    sudo wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt-get install -y ./google-chrome-stable_current_amd64.deb
    sudo rm -v google-chrome-stable_current_amd64.deb
    echo "70"
}

# Config
config_docker() {
    echo '# Setting docker user permissions'
    sudo usermod -a -G docker $(whoami)
    echo "30"
}

config_ssh_key() {
    echo '# Configuring ssh key'
    if [ ! -f ~/.ssh/id_rsa ]; then
        email=$(zenity --entry --title="SSH Key Generation" --text="Enter your email for SSH key generation:")
        if [ -z "$email" ]; then
            zenity --error --text="Email not provided. No private key generated."
        fi
        sudo ssh-keygen -t rsa -b 4096 -C "$email" -N "" -f ~/.ssh/id_rsa
    fi
    echo "60"
}

encrypt_home(){
    echo '# Encrypting /home/${whoami}'
    sudo apt-get install -y ecryptfs-utils
    echo "ecryptfs-migrate-home -u" $(whoami) > /tmp/encrypt_$(whoami).sh
    sudo mv /tmp/encrypt_$(whoami).sh /root
    sudo chmod +x /root/encrypt_$(whoami).sh

    if [ $? = 1 ]; then
        zenity --info --text="It's not possible to encrypt your home\n($HOME).\nCheck terminal for error logs."
        exit 1
    fi
    echo "90"
}


# Dialogs
install_dialog(){
    packages=$(zenity --list --title="Select install packages." --text="Choose optional packages to install:" --checklist --column="Select" --column="Package" \
        TRUE "Google Chrome" \
        TRUE "Slack" \
        TRUE "Visual Studio Code" \
        --separator=":")

    (
    sudo apt-get update
    packages="mandatory_packages:${packages}"
    IFS=":" read -ra selected_packages <<< "$packages"
    for package in "${selected_packages[@]}"; do
        case $package in
            "Google Chrome")
                install_chrome
                ;;
            "Visual Studio Code")
                install_vscode
                ;;
            "Slack")
                install_slack
                ;;
            "mandatory_packages")
                install_dev_tools
                install_gcloud
                install_kubectl
                install_docker
                ;;
        esac
    done

    ) | zenity --progress --title="Packages installation" --text="Starting..." --percentage=0 --auto-close --auto-kill
}

# Config dialog
config_dialog(){
    config_docker
    config_ssh_key 
    zenity --question --text="Do you want to encrypt the home directory of $(whoami)?" --title="Confirmation" 
    encrypt_choice=$?

    if [ -d /home/.ecryptfs/$(whoami) ]; then
       encrypt_choice=1
       zenity --info --text "${HOME} is already encrypted."
    fi

    if [ $encrypt_choice -eq 0 ]; then
        zenity --info --timeout=10 --text="Are you sure you have backed up the home directory of $(whoami) before executing the command?"
        encrypt_home
        zenity --info \
            --text="PLEASE READ CAREFULY BELOW
            \n1. Please logout your user $(whoami).
            \n2. Log as root (or an user with admin privileges) and execute\n/root/encrypt_$(whoami).sh.
            \n3. PAY ATTENTION CAREFULLY TO THE INSTRUCTIONS.
            \n4. After encrypt you must log in on $(whoami) and NOT REBOOT YOUR SYSTEM before log again.
            \n5. After login wait for a window prompting to define a passphrase to recently encrypted home."
    fi
}

main(){
    get_sudo_password

    ret=$(zenity --list --checklist \
        --text="Choose an option install packages or configure. For default both are enabled." \
        --column="Select" --column="Option" \
        TRUE "Packages" \
        TRUE "Configuration" \
        --separator=":" \
        --title="First Steps")
    
    IFS=":" read -ra ret <<< "$ret"
    for choice in "${ret[@]}"; do
        case $choice in
            "Packages")
                install_dialog
                ;;
            "Configuration")
                config_dialog
                ;;
        esac
    done
}

main