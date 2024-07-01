# Title: Encrypt Home Folder
# Description: Encrypt the home folder of the current user

encrypt_home(){
    echo "ecryptfs-migrate-home -u" $(whoami) > /tmp/encrypt_$(whoami).sh
    sudo mv /tmp/encrypt_$(whoami).sh /root
    sudo chmod +x /root/encrypt_$(whoami).sh

    if [ $? = 1 ]; then
        zenity --info --text="It's not possible to encrypt your home\n($HOME).\nCheck terminal for error logs."
        exit 1
    fi
}


# Question User to encrypt home folder
zenity --question --text="Do you want to encrypt the home directory of $(whoami)?" --title="Confirmation"
encrypt_choice=$?

if [ -d /home/.ecryptfs/$(whoami) ]; then
    zenity --info --text="Your home directory is already encrypted."
    exit 1
fi

if [ $encrypt_choice -eq 0 ]; then
    zenity --info --text="Are you sure you have backed up the home directory of $(whoami) before executing the command?"
    encrypt_home
    zenity --info \
        --text="PLEASE READ CAREFULLT BELOW INSTRUCTIONS
        \N1. Please logout your user $(whoami).
        \N2. Login as root (or another user with sudo privileges) and execute\n/root/encrypt_$(whoami).sh.
        \N3. PAY ATTENTION CAREFULLY TO THE INSTRUCTIONS.
        \N4. After encrypt you must log in on $(whoami) and NOT REBOOT YOUR SYSTEM before log again.
        \N5. After login wait for a window prompting to define a passphrase to recently encrypted home."
fi