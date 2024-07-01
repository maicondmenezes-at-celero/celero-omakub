# Title: Set Git
# Description: Set up Git with some common aliases
# Description: alis.co for git checkout, alias.br for git branch, alias.ci for git commit, alias.st for git status
# Description: Also set git pull to rebase by default

# Set common git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global pull.rebase true
