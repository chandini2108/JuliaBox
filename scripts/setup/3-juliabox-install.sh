#!/usr/bin/env bash

# Installation Part II
#--------------------------
sudo mkdir -p /jboxengine/conf /jboxengine/data/db /jboxengine/data/disks/host
sudo chown -R $USER: /jboxengine

# Create a configuration file /jboxengine/conf/jbox.user
MAX_USERS=30
cat << EOF > /jboxengine/conf/jbox.user
{
  "numdisksmax" : $((MAX_USERS+10)), 
  "admin_users" : ['devops@cybera.ca'], 
  "websocket_protocol" : "ws",
  "interactive": {
    "numlocalmax": ${MAX_USERS}
  },
  "plugins": [
    "juliabox.plugins.compute_singlenode",
    "juliabox.plugins.vol_loopback",
    "juliabox.plugins.vol_defpkg",
    "juliabox.plugins.vol_defcfg",
    "juliabox.plugins.auth_google",
    "juliabox.plugins.db_sqlite3"
  ],
  "google_oauth": {
    "key": "<MY-SECRET-KEY>",
    "secret": "<MY-SEKRET>"
  },
}    
EOF

# Generate JuliaBox configuration files:
bash ~/JuliaBox/scripts/install/jbox_configure.sh

# "Usage: sudo mount_fs.sh <data_location> <ndisks> <ds_size_mb> <fs_user_id>"
sudo bash ~/JuliaBox/scripts/install/mount_fs.sh /jboxengine/data ${MAX_USERS} 2048 ${USER}

# JuliaBox Docker image creation.
bash ~/JuliaBox/scripts/install/img_create.sh cont build
bash ~/JuliaBox/scripts/install/img_create.sh home /jboxengine/data

# JuliaBox services Docker image creation.
bash ~/JuliaBox/scripts/install/img_create.sh jbox

# JuliaBox database preperation
python ~/JuliaBox/scripts/install/create_tables_sqlite.py /jboxengine/data/db/juliabox.db

# Launch JuliaBox:
bash ~/JuliaBox/scripts/run/start.sh
