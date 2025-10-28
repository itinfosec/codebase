#!/bin/bash
## To use this script run chmod +x /path/to/docker_install.sh followed by ./docker_install.sh ##
set -e

echo "🚀 Starting Docker installation..."

# Update package index and install dependencies
echo "📦 Installing prerequisites..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# Set up the keyring directory
echo "🔐 Setting up Docker GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker's APT repository
echo "➕ Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index with Docker packages
echo "🔄 Updating APT sources..."
sudo apt-get update

# Install Docker Engine and tools
echo "🐳 Installing Docker Engine and components..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Run a test container
echo "✅ Verifying Docker installation..."
sudo docker run --rm hello-world

echo "🎉 Docker installation completed successfully!"
