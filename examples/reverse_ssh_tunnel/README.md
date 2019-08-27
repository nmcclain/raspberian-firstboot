# raspberian-firstboot

## Setup an automatic reverse SSH tunnel for remote management
1. Edit `firstboot/sshtun.service`:
	1. Confirm/update port for management server local port (example uses port `2223`).
	1. Update `USER@MANAGEMENTHOST` for your internet-accessible management server.
1. Copy USER's private key to `firstboot` directory.
1. Mount your image (works in Windows, MacOS, and Linux).
1. Copy `firstboot.sh` and `firstboot` directory to `/boot` partition (`/mnt/boot`, `/Volumes/boot`, etc.).
1. Unmount your image, burn it to SD, and test:
	1. On your management server, run `netstat -nl | grep 2223`
	1. It may take a few minutes for your tunnel to come up the first time.
	1. Once the tunnel is listening, connect to your Pi: `ssh pi@localhost -p2223`

## Troubleshoot
1. Connect a display & keyboard to your Pi.
1. Confirm/debug wifi connectivity.
1. Ensure it's possible to SSH to your mangement host using the same user/key set in `sshtun.service`
1. Confirm `firstboot.service` was successful:
	1. `/boot/firstboot.sh` was renamed to `/boot/firstboot.sh.done`
	1. Look for issues in `/var/log/`
1. Confirm `sshtun.service` was setup successfully:
	1. Confirm `sshtun.service` was installed in `/etc/systemd/system/sshtun.service`
	1. Confirm `sshtun.service` is running.
	1. Look for an `ssh` process that matches your `sshtun.service` config with `ps -elf | grep ssh`
	1. Look for issues in `/var/log/`
