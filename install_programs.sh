#!/bin/bash

# List of programs to install
programs=(
  curl
  git
  vim
  htop
  build-essential
  net-tools
  dog
  wormhole

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

echo "All done."
