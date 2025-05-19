#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -x

apt update -y
apt install -y nginx git

git clone https://github.com/Hendawyy/simple-3-tier-app.git /var/www/app

rm -f /var/www/html/index.html
cp /var/www/app/FrontEnd/index.html /var/www/html/

cat > /etc/nginx/sites-available/default << NGINX
server {
    listen 80;

    location / {
        root /var/www/html;
        index index.html;
        try_files \$uri \$uri/ =404;
    }

    location /api/increment {
        proxy_pass http://${back_alb_dns}:3000/api/increment;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
NGINX

systemctl enable nginx
systemctl restart nginx
