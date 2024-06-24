
# Check linux distro

if [ "$DISTRO" == "ubuntu" ]; then
    # install for ubuntu

    sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
    sudo apt update -y
    sudo apt install -y fastfetch

elif [ "$DISTRO" == "debian" ]; then
    # install for debian

    # Get system architecture
    ARCH=$(dpkg --print-architecture)

    # Set temp folder for download
    TEMP_FOLDER=$(mktemp -d)
    cd "$TEMP_FOLDER"

    # Get version number for the latest release of fastfetch
    LATEST_VERSION=$(\
        curl -Ls https://github.com/fastfetch-cli/fastfetch/releases/latest \
        | grep -oP 'href="/fastfetch-cli/fastfetch/releases/tag/\K[^"]+'
    )

    if [ -z "$LATEST_VERSION" ]; then
        echo "Failed to get latest version of fastfetch"
        exit 1
    fi

    # Build download URL
    DOWNLOAD_URL="https://github.com/fastfetch-cli/fastfetch/releases/download/$LATEST_VERSION/fastfetch-linux-$ARCH.deb"

    # Download fastfetch
    wget -O fastfetch.deb "$DOWNLOAD_URL"

    # Install fastfetch
    sudo apt install -y ./fastfetch.deb
fi

# Clean up

cd -
rm -rf "$TEMP_FOLDER"
unset TEMP_FOLDER
unset ARCH
unset LATEST_VERSION
