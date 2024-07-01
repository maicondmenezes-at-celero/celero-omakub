# Title: Set SSH Key
# Description: Generate an SSH key if it doesn't exist

if [ ! -f ~/.ssh/id_rsa ]; then
    email=$(zenity --entry --title="SSH Key Generation" --text="Enter your email for SSH key generation:")
    if [ -z "$email" ]; then
        zenity --error --text="Email not provided. No private key generated."
    fi
    sudo ssh-keygen -t rsa -b 4096 -C "$email" -N "" -f ~/.ssh/id_rsa
fi