#!/bin/bash

echo "Setup permission serial port for MCUs..."

if getent group uucp > /dev/null; then
	echo "Adding $USER to uucp group"
	sudo usermod -a -G uucp $USER 
fi

if getent group dialout > /dev/null; then
	echo "Adding $USER to dialout group" 
	sudo usermod -a -G dialout $USER 
fi

echo "Setup permission serial port complete."
echo "Setup udev rules to /etc/udev/rules.d/..."

sudo cp 99-board-clones.rules /etc/udev/rules.d/

sudo udevadm control --reload-rules
sudo udevadm trigger

echo "---------------------------------------------------------"
echo "PROCESS COMPLETE"
echo "Please logout or restart for makes these changes active."
echo "---------------------------------------------------------"
