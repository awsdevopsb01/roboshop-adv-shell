echo -e "************\e[36m Setup Mysql version ************\e[0m"
dnf module disable mysql -y
cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "************\e[36m Install Mysql ************\e[0m"
dnf install mysql-community-server -y

echo -e "************\e[36m Enable and Start Mysql ************\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "************\e[36m Reset Mysql default password ************\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1