echo -e "************\e[36m Copy Mongodb repo ************\e[0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "************\e[36m Install Mongodb ************\e[0m"
dnf install mongodb-org -y

echo -e "************\e[36m Update config file to listen from all servers ************\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf

echo -e "************\e[36m Enable & Start Mongodb service ************\e[0m"
systemctl enable mongod
systemctl restart mongod