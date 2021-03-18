#!/bin/sh -

echo Enabling joystick mapper...
sudo rmmod uinput
sudo modprobe uinput
sudo reserve_js
