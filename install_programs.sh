#!/bin/bash

# List of programs to install
programs=(
  curl
  git
  vim
  htop
  build-essential
  net-tools
  wormhole
  moreutils
  unp
  asciinema
  samba
  tmux
  screen
  
  


)

# List of Snap packages (name and optional flags)
snap_programs=(
  "dog"
)

echo "Updating package list..."
sudo apt update

echo "Installing programs..."
for program in "${programs[@]}"; do
  if dpkg -s "$program" &> /dev/null; then
    echo "$program is already installed."
  else
    echo "Installing $program..."
    sudo apt install -y "$program"
  fi
done

# install speedtest cli with curl
echo "Installing speedtest-cli with curl"
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install speedtest

echo "All done."
