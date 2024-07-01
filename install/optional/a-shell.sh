# Title: Configure Shell Environment
# Description: This script backs up existing shell configuration files and applies new settings.
# Description: It moves existing .bashrc and .inputrc files to backup files and replaces them with predefined configurations.

[ -f "~/.bashrc" ] && mv ~/.bashrc ~/.bashrc.bak
cp ~/.local/share/omakub/configs/bashrc ~/.bashrc
source ~/.local/share/omakub/defaults/bash/shell

[ -f "~/.inputrc" ] && mv ~/.inputrc ~/.inputrc.bak
cp ~/.local/share/omakub/configs/inputrc ~/.inputrc
