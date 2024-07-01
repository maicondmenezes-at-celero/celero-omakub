# Title: Set up emojis
# Description: Set up emojis for easy access

cp ~/.local/share/omakub/configs/xcompose ~/.XCompose
ibus restart
gsettings set org.gnome.desktop.input-sources xkb-options "['compose:caps']"
