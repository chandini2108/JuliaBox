#!/usr/bin/env bash

# Preparation
#---------------------
# prepare the docker host for a multi-user installation.  Because we're changing
# grup configuration, we'll need to re-boot after this 
sudo sed -i -r 's/(GRUB_CMDLINE_LINUX=".*)(")/\1 max_loop=64"/g' /etc/default/grub
sudo sed -i -r 's/(GRUB_CMDLINE_LINUX=".*)(")/\1 cgroup_enable=memory swapaccount=1"/g' /etc/default/grub
sudo sed -i 's/GRUB_CMDLINE_LINUX=" /GRUB_CMDLINE_LINUX="/g' /etc/default/grub
sudo update-grub
sudo reboot
