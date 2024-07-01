# Title: Install default programming languages using asdf
# Description: This script installs the default programming languages using asdf and Docker-based databases.

# Install default programming languages
languages=$(gum choose "Ruby on Rails" "Node.js" "Go" "PHP" "Python" "Elixir" "Java" --no-limit --selected "Ruby on Rails","Node.js" --height 9 --header "Select programming languages")

for language in $languages; do
    case $language in
    "Ruby on Rails")
        asdf install ruby latest
        asdf global ruby latest
        gem install rails --no-document
        ;;
    "Node.js")
        asdf install nodejs latest
        asdf global nodejs latest
        ;;
    "Go")
        asdf install golang latest
        asdf global golang latest
        code --install-extension golang.go
        ;;
    "Java")
        asdf install java latest
        asdf global java latest
        ;;
    "Python")
        asdf install python latest
        asdf global python latest
        ;;
    "Elixir")
        asdf install erlang latest
        asdf global erlang latest
        asdf install elixir latest
        asdf global elixir latest
        mix local.hex --force
        ;;
    "PHP")
        sudo add-apt-repository -y ppa:ondrej/php
        sudo apt -y install php8.3 php8.3-{curl,apcu,intl,mbstring,opcache,pgsql,mysql,sqlite3,redis,xml,zip}
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
        php composer-setup.php --quiet && sudo mv composer.phar /usr/local/bin/composer
        rm composer-setup.php
        ;;
    esac
done
