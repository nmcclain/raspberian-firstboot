#!/bin/bash

LOGFILE="/boot/firstboot.log"

# Log everything: https://serverfault.com/a/103569/662521
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>${LOGFILE} 2>&1

echo "updating APT..."
export DEBIAN_FRONTEND=noninteractive
apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false
apt-get install -y upgrade

echo "setting timezone and updating time"
timedatectl set-timezone UTC
ntpdate ntp.ubuntu.com

# Reboot delayed, so that we can exit with success to complete firstboot.service
echo "scheduling reboot in 3 seconds"
systemd-run --no-block sh -c "sleep 3 && touch /boot/reboot && reboot"

echo "Done firstboot, exit, but reboot in 3 seconds"
exit 0

# check /boot/reboot and /boot/firstboot.log
