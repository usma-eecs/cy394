#!/usr/bin/env bash
set -euo pipefail

sudo apt update -y
sudo apt upgrade -y
sudo apt install apache2 -y

sudo a2enmod proxy proxy_http proxy_balancer lbmethod_bytraffic

read -p "Enter the Flask IP address: " flaskip
read -p "Enter the Flask port [5000]: " flaskport
flaskport="${flaskport:-5000}"

sudo tee /etc/apache2/sites-available/flask.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName cy394.com

    <Proxy balancer://flaskbalancer/>
        BalancerMember http://${flaskip}:${flaskport}/
        ProxySet lbmethod=bytraffic
    </Proxy>

    ProxyPass "/" "balancer://flaskbalancer/"
    ProxyPassReverse "/" "balancer://flaskbalancer/"
</VirtualHost>

<Location "/balancer-manager">
    SetHandler balancer-manager
    Require host localhost
</Location>
EOF

sudo ln -sf /etc/apache2/sites-available/flask.conf /etc/apache2/sites-enabled/flask.conf
sudo rm -f /etc/apache2/sites-enabled/000-default.conf

sudo systemctl restart apache2
echo "Apache reverse proxy configured -> http://${flaskip}:${flaskport}/"
