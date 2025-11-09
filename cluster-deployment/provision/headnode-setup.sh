#!/bin/bash
# Update system
sudo dnf update -y

# Install necessary tools
sudo dnf install -y net-tools iproute traceroute vim

# Set hostname (optional if done in Vagrantfile)
sudo hostnamectl set-hostname headnode

# Configure internal network
sudo ip addr add 10.0.0.1/24 dev enp0s8
sudo ip link set enp0s8 up

# Enable IP forwarding so compute nodes can reach the internet
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo sysctl -w net.ipv4.ip_forward=1

# Configure NAT/iptables (optional)
sudo iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o enp0s3 -j MASQUERADE
sudo iptables -A FORWARD -i enp0s8 -o enp0s3 -j ACCEPT
sudo iptables -A FORWARD -i enp0s3 -o enp0s8 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo dnf install -y iptables-services
sudo systemctl enable iptables
sudo systemctl start iptables

# Add /etc/hosts entries for cluster nodes
echo "10.0.0.1 headnode" | sudo tee -a /etc/hosts
echo "10.0.0.2 computenode" | sudo tee -a /etc/hosts
