# Title: Kubectl
# Description: The Kubernetes command-line tool

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

download_file(){
    local link=$1
    local filepath=/tmp/${RANDOM}

    curl $link -o $filepath
    FILEPATH=$filepath
}

if [ "$DISTRO" == "ubuntu" ]; then
    # Ubuntu-specific installation steps
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 234654DA9A296436
    download_file https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key
    dearmor_gpg_key $FILEPATH /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list

elif [ "$DISTRO" == "debian" ]; then
    # Debian-specific installation steps
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    sudo chmod a+r /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ $(. /etc/os-release && echo "$VERSION_CODENAME") main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
fi

# Common installation steps
sudo apt update
sudo apt install -y kubectl

