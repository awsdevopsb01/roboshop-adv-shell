echo -e "************\e[36m Set correct Nodejs version *********\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "************\e[36m Install Nodejs ************\e[0m"
dnf install nodejs -y

echo -e "************\e[36m Add Functional User *********\e[0m"
useradd roboshop

echo -e "************\e[36m Create app directory *********\e[0m"
rm -rf /app
mkdir /app

echo -e "************\e[36m Download the code *********\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "************\e[36m Unzip the code *********\e[0m"
cd /app
unzip /tmp/catalogue.zip
echo -e "************\e[36m Install Dependencies *********\e[0m"
npm install

echo -e "************\e[36m Copy the Catalogue service *********\e[0m"
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

echo -e "************\e[36m Start Catalogue service *********\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "************\e[36m Copy Mongodb repo *********\e[0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "************\e[36m Install mongodb *********\e[0m"
dnf install mongodb-org-shell -y

echo -e "************\e[36m Load Mongodb *********\e[0m"
mongo --host mongodb-dev.nldevopsb01.online </app/schema/catalogue.js

systemctl restart catalogue