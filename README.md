# board-clone-fix
Fixing the issue in Arduino UNO and ESP8266 (CH340) clones and ESP32 (CP2102) clones

## The Problem (and why it's annoying)

If you've ever worked with cheap Arduino UNO, Nano, ESP8266, or ESP32 clones in Linux, you've probably run into these headaches:

**Permission Hell:** You try to upload your sketch and encountered with "Permission Denied." You may could run your IDE with `sudo`, but that's too overkill and potentially dangerous.

**The 'Dissapearing' Port:** You try to use `/dev/ttyUSB0` for your projects because yesterday your board was there. Today, it's on `/dev/ttyUSB1`. Sure, it could be more annoying if you use more than one board (and not only boards, sometimes your peripherals too) or unstable tools such as `screen`, because you'll end up playing "guess the port" every time you plug something in.

The culprit? Most clones use dirt-cheap USB-to-serial chips (**CH340** or **CP2102**) that Linux treats like any other random USB device.

## The Fix

We're going to use udev rules to:
- Give your board a permanent name (e.g `/dev/myESP32` that never changes)
- Set permission correctly so you don't need sudo
Once this is set up, you'll never get these annoying problems.

## What You'll Need

This guide works for board with these common USB-to-Serial chips (specifficaly these cheap and clone boards)

| Chip   | Usually found in                 | Vendor ID | Product ID |
| ------ | -------------------------------- | --------- | ---------- |
| CH340  | Arduino UNO, ESP8266, Nano, Mega | `1a86`    | `7523`     |
| CP2102 | ESP32, NodeMCU                   | `10c4`    | `ea60`     |

## How-to-Setup 

**First**, copy the ``99-board-clones.rules`` file into udev rules directory.
```bash
sudo cp 99-board-clones.rules /etc/udev/rules.d/
```
**Second**, reload the udev system so it notices the new file (no reboot required)
```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```
**Lastly,** unplug your board and plug it back. Check if the permission and names are correct.
```bash
ls -l /dev/my*
```

The output should be like this:
```bash
$ ls -l /dev/my*
lrwxrwxrwx 1 root root 26 Jan 26 06:02 /dev/myESP32 -> ttyUSB0
```
or 
```bash
$ ls -l /dev/my*
lrwxrwxrwx 1 root root 26 Jan 26 05:31 /dev/myUNO -> ttyUSB0
```

## Using Your New Setup

### In Arduino IDE or PlatformIO

Instead of constantly changing the port to match whatever `/dev/ttyUSBx` your board decided to be today, just select (or manually type):
- `/dev/myESP32`
- `/dev/myUNO`
No more guessing. No more permission errors. Just plug in and upload.

## Troubleshooting

**Nothing shows up after unplugging/replugging?**
- Make sure you're using a data cable, not a charge-only cable. Yes, those exist, and yes, they're infuriating.

**Different IDs? **
- Some boards use FTDI chips (`0403:6001`) or other variants. Just update the `idVendor` and `idProduct` values in the rules file to match what you see. (You can use `lsusb` or `udevadm info`).

**Still getting permission errors?**
- Make sure you ran the `udevadm` commands and unplugged/replugged the device.

## Final Thoughts

This is one of those "set it and forget it" fixes. Once it's done, it just works. No more fighting with ports, no more permission headaches—just the way it should be.