#!/bin/bash

# disable ipv6
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

# enable/start ssh
systemctl enable ssh
systemctl start ssh

# install private ssh key
mkdir /root/.ssh/
chmod 700 /root/.ssh/
cp /boot/firstboot/id_rsa /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa

# install/enable/start sshtun service
cp /boot/firstboot/sshtun.service /etc/systemd/system/sshtun.service
systemctl enable sshtun
systemctl start sshtun

