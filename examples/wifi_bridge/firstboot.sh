#!/bin/bash

# disable ipv6
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

# install wifi configs for hostAP interface
cp /boot/firstboot/wpa_supplicant-wlan1.conf /etc/wpa_supplicant/wpa_supplicant-wlan1.conf

# enable ip forwarding
sed -i 's/#net.ipv4.ip_forward=./net.ipv4.ip_forward=1/' /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward

# install dependencies
DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install hostapd netfilter-persistent iptables-persistent dnsmasq

echo "
interface wlan1
static ip_address=192.168.5.1/24
nohook wpa_supplicant

listen-address=127.0.0.1,192.168.5.1
bind-interfaces" >> /etc/dhcpcd.conf
service dhcpcd restart

echo "
interface=wlan1
listen-address=192.168.5.1
bind-dynamic
server=8.8.8.8
domain-needed
bogus-priv
dhcp-range=192.168.5.10,192.168.5.110,48h" >> /etc/dnsmasq.conf
service dnsmasq restart

# configure and restart hostapd
cp /boot/firstboot/hostapd.conf /etc/hostapd/hostapd.conf
systemctl unmask hostapd.service
service hostapd restart

# configure iptables for NAT
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
iptables -A FORWARD -i wlan0 -o wlan1 -m state --state RELATED,ESTABLISHED -j ACCEPT  
iptables -A FORWARD -i wlan1 -o wlan0 -j ACCEPT
iptables-save > /etc/iptables/rules.v4
