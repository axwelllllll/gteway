#!/bin/bash

sudo echo source /etc/network/interfaces.d/* > /etc/network/interfaces

sudo echo auto lo >> /etc/network/interfaces
sudo echo iface lo inet loopback >> /etc/network/interfaces

sudo echo auto enp0s3 >> /etc/network/interfaces
sudo echo iface enp0s3 inet static >> /etc/network/interfaces

sudo echo address 192.168.0.2 >> /etc/network/interfaces
sudo echo netmask 255.255.255.128 >> /etc/network/interfaces

sudo echo auto enp0s8 >> /etc/network/interfaces
sudo echo iface enp0s8 inet dhcp >> /etc/network/interfaces

sudo /etc/init.d/networking restart

sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -X

sudo iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE
sudo iptables-save > /etc/iptables.save
