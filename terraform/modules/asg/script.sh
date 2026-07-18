#!/bin/bash
set -euxo pipefail

########################################################
# Project : AWS 3-Tier Architecture
# Purpose : EC2 Bootstrap Script
# Author  : Sunil Chouhan
########################################################

export DEBIAN_FRONTEND=noninteractive

########################################################
# Update Packages
########################################################

apt update -y

########################################################
# Install Required Packages
########################################################

apt install -y \
    nginx \
    git \
    curl \
    unzip \
    zip \
    snapd

########################################################
# Install AWS CLI v2
########################################################

cd /tmp

curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
    -o awscliv2.zip

unzip -q awscliv2.zip

./aws/install

rm -rf aws awscliv2.zip

########################################################
# Install Node.js 18
########################################################

curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

apt update -y

apt install -y nodejs

########################################################
# Install PM2
########################################################

npm install -g pm2

########################################################
# Install Amazon SSM Agent
########################################################

snap install amazon-ssm-agent --classic || true

systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service || true

systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service || true

########################################################
# Create Directories
########################################################

mkdir -p /opt/scripts

mkdir -p /opt/employee-management-system/backend

mkdir -p /var/www/html

########################################################
# Backend Environment File
########################################################

cat >/opt/employee-management-system/backend/.env <<EOF
PORT=5000

DB_HOST=${db_host}
DB_PORT=5432
DB_NAME=${db_name}
DB_USER=${db_user}
DB_PASSWORD=${db_password}
DB_SSL=true
EOF

########################################################
# Configure Nginx
########################################################

cat >/etc/nginx/sites-available/default <<EOF
server {

    listen 80;
    listen [::]:80;

    server_name _;

    root /var/www/html;

    index index.html;

    location / {

        try_files \$uri \$uri/ /index.html;

    }

    location /api {

        proxy_pass http://127.0.0.1:5000;

        proxy_http_version 1.1;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

    }

}
EOF

########################################################
# Enable Nginx
########################################################

systemctl enable nginx

nginx -t

systemctl restart nginx

########################################################
# Configure PM2 Startup
########################################################

pm2 startup systemd -u ssm-user --hp /home/ssm-user || true

########################################################
# Bootstrap Verification
########################################################

echo "========== Bootstrap Summary =========="

node -v

npm -v

pm2 -v

nginx -v

aws --version

echo "======================================="

echo "Bootstrap completed successfully."