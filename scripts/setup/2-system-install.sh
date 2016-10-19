#!/usr/bin/env bash

# Installation Part I
#--------------------------
sudo apt-get update && sudo apt-get install -y git
git clone https://github.com/cybera/JuliaBox.git

# this script will install docker (among other things) so that 
# the ubuntu user can manage docker
bash ~/JuliaBox/scripts/install/sys_install.sh

echo "* * * * * * * * * * * * * * * * * * * * * * * *"
echo "*                                             *"
echo "* log out of this session, then log in again, *"
echo "* so that the ubuntu user's docker privileges *"
echo "* are available.                              *"
echo "*                                             *"
echo "* * * * * * * * * * * * * * * * * * * * * * * *"

