echo -e "************\e[36m Install NGINX ************\e[0m"
dnf install nginx -y

echo -e "************\e[36m Enable & Start NGINX ************\e[0m"
systemctl enable nginx
systemctl start nginx

echo -e "************\e[36m Remove default html files ************\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "************\e[36m Download frontend code ************\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html

echo -e "************\e[36m Unzip frontend files ************\e[0m"
unzip /tmp/frontend.zip

echo -e "************\e[36m Copy Roboshop Config file ************\e[0m"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "************\e[36m ReStart NGINX ************\e[0m"
systemctl restart nginx