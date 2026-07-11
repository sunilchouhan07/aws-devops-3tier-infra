# #!/bin/bash 

# set -e 

# ENVIRONMENT="${environment}"

# apt update -y 

# apt install -y \
# nginx \
# curl \
# git \
# unzip



# curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

# apt install -y nodejs



# npm install -g pm2 



# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"

# cd /tmp

# unzip awscliv2.zip

# ./aws/install




# systemctl enable nginx

# systemctl start nginx




# mkdir -p /opt/app

# cd /opt/app



# aws s3 cp \
# s3://${artifact_bucket_name}/latest/frontend-build.zip \
# frontend-build.zip

# aws s3 cp \
# s3://${artifact_bucket_name}/latest/backend.tar.gz \
# backend.tar.gz



# mkdir -p frontend

# unzip frontend-build.zip -d frontend

# rm -rf /usr/share/nginx/html/*

# cp -r frontend/* /usr/share/nginx/html


# mkdir -p backend

# tar -xzf backend.tar.gz -C backend 

# cat <EOF backend.env
# DB_HOST=${db_host}
# DB_PORT=5432
# DB_NAME=${db_name}
# DB_USER=${db_user}
# DB_PASSWORD=${db_password}
# NODE_ENV=production
# EOF


# cd backend 

# npm install --omit=dev


# pm2 start server.js --name employee-backend || pm2 restart employee-backend

# pm2 save


# cat <EOF /etc/nginx/sites-available/default
# server {

# listen 80;

# root /usr/share/nginx/html;
# index index.html;

# location / {
#     try_files \$uri \$uri/ /index.html;
# }

# location /api/ {

#     proxy_pass http://localhost:5000;

#     proxy_http_version 1.1;

#     proxy_set_header Host \$host;
#     proxy_set_header X-Real-IP \$remote_addr;
#     proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
# }

# }
# EOF

# nginx -t

# systemctl restart nginx

# echo "Bootstrap completed successfully."


