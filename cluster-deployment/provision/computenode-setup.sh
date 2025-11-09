#!/bin/bash
# Update system
sudo dnf update -y

# Install tools
sudo dnf install -y net-tools iproute vim

# Set hostname
sudo hostnamectl set-hostname computenode

# Configure internal network (since no NAT, must be manual)
sudo ip addr add 10.0.0.2/24 dev enp0s3  # adjust interface name if needed
sudo ip link set enp0s3 up

# Add /etc/hosts entries for cluster nodes
echo "10.0.0.1 headnode" | sudo tee -a /etc/hosts
echo "10.0.0.2 computenode" | sudo tee -a /etc/hosts
