#!/usr/bin/env bash
set -euo pipefail

sudo apt update -y
sudo apt upgrade -y
sudo apt install python-is-python3 python3-pip -y

cd cy394/hw1
pip3 install -r requirements.txt
cd ~
