# Title: Google Cloud SDK
# Description: The SDK for Google Cloud Platform

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

download_file https://packages.cloud.google.com/apt/doc/apt-key.gpg && dearmor_gpg_key $FILEPATH /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt update
sudo apt install -y google-cloud-cli
sudo apt install -y google-cloud-cli-skaffold