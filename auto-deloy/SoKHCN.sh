#!/bin/bash

mkdir ~/workspaces
cd ~/workspaces && git clone git@github.com:btsco/SoKHCNVTAPI.git


sudo tee /etc/nginx/sites-available/SoKHCNVT.conf <<EOF
server {
    listen        7001;
    server_name   42.112.26.180;
    location / {
        proxy_pass         http://127.0.0.1:6001;
        proxy_http_version 1.1;
        proxy_set_header   Upgrade \$http_upgrade;
        proxy_set_header   Connection keep-alive;
        proxy_set_header   Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto \$scheme;
    }
}
EOF
sudo ln -s /etc/nginx/sites-available/SoKHCNVT.conf /etc/nginx/sites-enabled/SoKHCNVT.conf
sudo nginx -s reload

# crontab
mkdir -p /opt/cron
crontab -l > /opt/cron/SoKHCNVT
echo "* * * * * ~/workspaces/auto-deloy-dotnet-staging-env.sh" >> /opt/cron/SoKHCNVT
crontab /opt/cron/SoKHCNVT
