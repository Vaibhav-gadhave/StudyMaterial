#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== 1. Removing old versions (if any) == "
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt-get remove -y $pkg || true
done

echo "=== 2. Setting up Docker's apt repository ==="
# Update package index and install prerequisites
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=== 3. Installing Docker Engine ==="
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== 4. Configuring user permissions ==="
# Add current user to the docker group to run docker without sudo
sudo usermod -aG docker $USER

echo "=== 5. Verifying installation ==="
sudo docker run --rm hello-world

echo "=== Docker installation completed successfully! ==="
echo "Note: Please log out and log back in (or run 'newgrp docker') for the group permissions to take effect."
