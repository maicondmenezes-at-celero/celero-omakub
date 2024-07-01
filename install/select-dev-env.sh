# Title: Choose Development Environment Manager
# Description: This script allows the user to choose between mise or asdf for the development environment manager.

env_manager=$(gum choose "mise" "asdf" --height 5 --header "Select the development environment manager")

case $env_manager in
mise)
    bash ~/.local/share/omakub/install/select-dev-env-mise.sh
    ;;
asdf)
    bash ~/.local/share/omakub/install/select-dev-env-asdf.sh
    ;;
esac

# Install default databases
dbs=$(gum choose "MySQL" "Redis" "PostgreSQL" --no-limit --selected "MySQL","Redis" --height 5 --header "Select databases (runs in Docker)")

for db in $dbs; do
    case $db in
    "MySQL")
        sudo docker run -d --restart unless-stopped -p "127.0.0.1:3306:3306" --name=mysql8 -e MYSQL_ROOT_PASSWORD= -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql:8.4
        ;;
    "Redis")
        sudo docker run -d --restart unless-stopped -p "127.0.0.1:6379:6379" --name=redis redis:7
        ;;
    "PostgreSQL")
        sudo docker run -d --restart unless-stopped -p "127.0.0.1:5432:5432" --name=postgres16 -e POSTGRES_HOST_AUTH_METHOD=trust postgres:16
        ;;
    esac
done