# Bridge traffic from a Raspberry PI Host AP to an upstream WiFi network

## Setup
1. You'll need a USB WiFi dongle, which will be used for the host AP WiFi network. https://www.raspberrypi.com/products/raspberry-pi-usb-wifi-dongle/
  1. Note: the wlan0 interface will be used to connect to your upstream WiFi network; wlan1 is for your local Raspberry Pi WiFi network.
1. Mount your image (works in Windows, MacOS, and Linux).
1. Set SSIDs and passphrases:
  1. Edit `firstboot/wpa_supplicant.conf`: set `ssid` and `psk`, marked with `XXX`
  1. * Edit `firstboot/hostapd.conf`: set `ssid` and `wpa_passphrase`, marked with `XXX`
1. Copy `firstboot.sh` and `firstboot` directory to `/boot` partition (`/mnt/boot`, `/Volumes/boot`, etc.).
1. Unmount your image, burn it to SD, and test:
  1. It will take a few minutes for your host AP to come up the first time.
  1. Connect to your Pi at the SSID you configured above.
