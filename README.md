# raspberian-firstboot
A lightly modified Raspbian-light image with first boot customization.

Our goal is **easy** boot time customization of **the** standard Raspberry Pi OS - just edit a simple bash script.

**Download the image from the [Releases tab](../../releases).**

# Why would I use this image?
The standard [Raspbian-lite](https://www.raspberrypi.org/downloads/raspbian/)
image allows you to customize the wireless settings and enable SSHd before flashing it to an SD card. Unfortunately, there is no way to further customize the OS during the first boot, nothing like cloud-init or userdata. Without a display and keyboard, complex "headless" deployments are impossible.

With this image, you can run a custom script on first boot and:
* Set a unique hostname. ([simple example](examples/simple_hostname/))
* Configure HDMI, audio, and network settings. ([example](examples/audio/))
* Install apt software packages. ([example](examples/apt_packages/))
* Setup an automatic reverse SSH tunnel for remote management. ([example](examples/reverse_ssh_tunnel/))
* Bootstrap a configuration management tool like Ansible/Chef/Puppet to prevent configuration drift.
* Deploy your IoT fleet with custom UUIDs and configurations.

# Quick Start
There are two ways to use the image, pick one:

* A. Download the image, customize the image with firstboot scripts, then flash the customized image to your SD card.

* B. Download the image, flash the image to your SD card, then customize the SD card with firstboot scripts.

## Quick Start A
1. Download the latest image from the [Releases tab](../../releases). Note we currenlty only support the raspbian-lite image.
1. Mount the `/boot` volume OF THE IMAGE YOU JUST DOWNLOADED. This usually happens automatically if you "open" the image on Windows, MacOS, or Linux.
1. NOTE: references below to /mnt will be /Volumes on macos and under "My Computer" on Windows.
1. Create a `/mnt/boot/firstboot.sh` script with your custom contents [examples here](examples/).
1. Optionally add additional custom configuration files or small binaries to /mnt/boot (the /boot partiton is small - keep your total additions under ~160MB).
1. Remember, you can also add a [/mnt/boot/wpa_supplicant.conf](https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md) file for wifi configuration.
1. Unmount the `/boot` volume: `umount /mnt` on linux, `diskutil unmount /Volumes/boot` on macos, right-click for Windows.
1. Flash the customized image to your SD card. **We recommend using Balena Etcher for writing images on all platforms.** Folks have run into issues with the official `Raspberry Pi Imager`.
1. Boot your Pi... `/boot/firstboot.sh` will be executed and renamed to `/boot/firstboot.sh.done`.

## Quick Start B
1. Download the latest image from the [Releases tab](../../releases). Note we currenlty only support the raspbian-lite image.
1. Flash the downloaded image to your SD card. **We recommend using Balena Etcher for writing images on all platforms.** Folks have run into issues with the official `Raspberry Pi Imager`.
1. Mount the `/boot` volume OF YOUR THE SD CARD YOU JUST FLASHED. This usually happens automatically if you "open" the SD card volume on Windows, MacOS, or Linux.
1. NOTE: references below to /mnt will be /Volumes on macos and under "My Computer" on Windows.
1. Create a `/mnt/boot/firstboot.sh` script with your custom contents [examples here](examples/).
1. Optionally add additional custom configuration files or small binaries to /mnt/boot (the /boot partiton is small - keep your total additions under ~160MB).
1. Remember, you can also add a [/mnt/boot/wpa_supplicant.conf](https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md) file for wifi configuration.
1. Unmount the `/boot` volume: `umount /mnt` on linux, `diskutil unmount /Volumes/boot` on macos, right-click for Windows.
1. Boot your Pi... `/boot/firstboot.sh` will be executed and renamed to `/boot/firstboot.sh.done`.

# What changes were made to the standard Raspbian-lite image?
1. [firstboot.service](firstboot.service) is installed in `/lib/systemd/system/firstboot.service`
1. firstboot.service is enabled: `cd /etc/systemd/system/multi-user.target.wants && ln -s /lib/systemd/system/firstboot.service .`
1. Nothing else!

# How to reproduce this image yourself
1. This requires modifying the second partition of the Raspbian image, which requires Linux for ext4 support.
2. Source image is obtained from the official Raspberry Pi [download page](https://www.raspberrypi.org/downloads/raspbian/).
3. Be sure to verify the SHA hash!
4. Mount the second partition of the source image - the `mount` command will require an `--offset` flag, [as described here](https://raspberrypi.stackexchange.com/questions/13137/how-can-i-mount-a-raspberry-pi-linux-distro-image).
   * Note: the [mount_offset_tool](mount_offset_tool/) helps calculate the `--offset` on linux.
   * Example usage (thanks @tgelite):
```
$ cd mount_offset_tool/
$ go run main.go /media/share/2021-01-11-raspios-buster-armhf-lite.img
/media/share/2021-01-11-raspios-buster-armhf-lite.img1 mount command:
  mount -v -o offset=4194304,loop /media/share/2021-01-11-raspios-buster-armhf-lite.img /mnt
/media/share/2021-01-11-raspios-buster-armhf-lite.img2 mount command:
  mount -v -o offset=272629760,loop /media/share/2021-01-11-raspios-buster-armhf-lite.img /mnt
```
   * Alternatively, you can mount it with `guestmount` (thanks @bastien-roucaries):
$ guestmount -v -a 2021-01-11-raspios-buster-armhf-lite-firstboot.img -m /dev/sda2 -m /dev/sda1:/boot /mnt
later, unmount with: $ guestunmount /mnt
```
5. Install [firstboot.service](firstboot.service) in `/mnt/lib/systemd/system/firstboot.service`
6. Enable firstboot.service for systemd: `cd /mnt/etc/systemd/system/multi-user.target.wants && ln -s /lib/systemd/system/firstboot.service .`
7. Unmount the second partition of the source image.
8. Carefully test & validate the image before distributing!

