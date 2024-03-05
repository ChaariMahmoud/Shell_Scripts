#!/bin/bash

#Update the system
sudo apt update
#Install prerequisite packages (git, ZSH, powerline & powerline fonts)
sudo apt install git -y
sudo apt install zsh -y
sudo apt-get install powerline fonts-powerline -y
#Clone the Oh My Zsh Repository
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
#Create a New ZSH configuration file
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
#Install PowerLevel9k!
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9
#Configure .zshrc file 
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel9k\/powerlevel9k"/' ~/.zshrc
sed -i '/^POWERLEVEL9K_DISABLE_RPROMPT/d' ~/.zshrc
sed -i '/^POWERLEVEL9K_PROMPT_ON_NEWLINE/d' ~/.zshrc
sed -i '/^POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX/d' ~/.zshrc
sed -i '/^POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX/d' ~/.zshrc

echo 'POWERLEVEL9K_DISABLE_RPROMPT=true' >> ~/.zshrc
echo 'POWERLEVEL9K_PROMPT_ON_NEWLINE=true' >> ~/.zshrc
echo 'POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="▶"' >> ~/.zshrc
echo 'POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""' >> ~/.zshrc
#Change your Default Shell to zsh 
chsh -s /bin/zsh
#Restart the terminal
echo "Please restart your terminal to apply the changes."
echo "If any think went wrong change shell to bash 'chsh -s /bin/bash'"
