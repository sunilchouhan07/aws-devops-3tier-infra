#!/bin/bash
set -euxo pipefail

# --------------------------------------------------
# Project : AWS 3-Tier Architecture
# Purpose : Bootstrap EC2 Instance
# Author  : Sunil Chouhan
# --------------------------------------------------

export DEBIAN_FRONTEND=noninteractive

############################################
# Update Packages
############################################

apt update -y

############################################
# Install Required Packages
############################################

apt install -y \
    nginx \
    git \
    curl \
    unzip \
    npm

############################################
# Install PM2
############################################

npm install -g pm2

############################################
# Clone Repository
############################################

cd /home/ubuntu

if [ ! -d employee_management_system ]; then
    git clone https://github.com/sunilchouhan07/employee_management_system.git
fi

cd employee_management_system

############################################
# Backend
############################################

cd backend

npm install

cat > .env <<EOF
PORT=5000

DB_HOST=${db_host}
DB_PORT=5432
DB_NAME=${db_name}
DB_USER=${db_user}
DB_PASSWORD=${db_password}
DB_SSL=true
EOF

pm2 start server.js --name backend || pm2 restart backend

pm2 save

############################################
# Frontend
############################################

cd ../frontend

npm install

npm run build

############################################
# Deploy React Build
############################################

rm -rf /var/www/html/*

cp -r build/* /var/www/html/

############################################
# Nginx Configuration
############################################

cat > /etc/nginx/sites-available/default <<EOF
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

############################################
# Restart Nginx
############################################

nginx -t

systemctl enable nginx

systemctl restart nginx

############################################
# PM2 Startup
############################################

pm2 startup systemd -u ubuntu --hp /home/ubuntu

############################################
# Bootstrap Complete
############################################

echo "Deployment completed successfully."