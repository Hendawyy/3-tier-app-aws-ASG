#!/bin/bash
exec > /var/log/backend-user-data.log 2>&1
set -x

sudo apt update -y
sudo apt install -y curl git

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

git clone https://github.com/Hendawyy/simple-3-tier-app.git /home/ubuntu/app

cd /home/ubuntu/app/BackEnd
npm install

nohup node server.js > server.log 2>&1 &
