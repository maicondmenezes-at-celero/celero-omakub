# Title: Docker
# Description: The popular containerization platform

# Check linux distro

if [ "$DISTRO" == "ubuntu" ]; then
    # Add the official Docker repo
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update

    # Install Docker engine and standard plugins
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

elif [ "$DISTRO" == "debian" ]; then

    # Remove old Docker versions
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt remove $pkg; done

    # Add Docker's official GPG key:
    sudo apt update
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update

    # Install Docker engine and standard plugins
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi
# Post-installation steps

# Docker group if dont exist
if ! getent group docker > /dev/null; then
    sudo groupadd docker
fi

# Give this user privileged Docker access
sudo usermod -aG docker ${USER}

# Activate the changes
newgrp docker

# Use local logging driver - it's more efficient and uses compression by default.
echo '{"log-driver":"local","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json > /dev/null
