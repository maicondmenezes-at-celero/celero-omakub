# Title: Zoom
# Description: A video conferencing software

cd /tmp
wget https://zoom.us/client/latest/zoom_amd64.deb
sudo apt install -y ./zoom_amd64.deb
rm zoom_amd64.deb
cd -
