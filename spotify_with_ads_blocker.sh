#!/bin/bash

#Update the system 
sudo apt update 
#intall curl 
sudo apt install curl
#Configure our debian repository
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
#Re-update the system 
sudo apt update 
#Install the Spotify client
sudo apt-get install spotify-client
#Install spotx
bash <(curl -sSL https://spotx-official.github.io/run.sh)
