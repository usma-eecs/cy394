#!/usr/bin/env bash
set -euo pipefail

sudo apt update -y
sudo apt upgrade -y
sudo apt install mysql-server -y

sudo sed -i -E 's/^\s*bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl restart mysql

password="$(sudo awk '/password/{p=$3} END{print p}' /etc/mysql/debian.cnf)"
echo "Opening MySQL as debian-sys-maint (password extracted from /etc/mysql/debian.cnf)..."
mysql -u debian-sys-maint -p"${password}"
