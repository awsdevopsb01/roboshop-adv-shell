echo -e "************\e[36m Install Maven ************\e[0m"
dnf install maven -y

echo -e "************\e[36m Create Functional User ************\e[0m"
useradd roboshop

echo -e "************\e[36m Create App directory ************\e[0m"
rm -rf /app
mkdir /app

echo -e "************\e[36m Download App Content ************\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e "************\e[36m Extract App Content ************\e[0m"
cd /app
unzip /tmp/shipping.zip

echo -e "************\e[36m Install Dependencies ************\e[0m"
mvn clean package

echo -e "************\e[36m Move Shipping.jar file ************\e[0m"
mv target/shipping-1.0.jar shipping.jar

echo -e "************\e[36m Copy Shipping service ************\e[0m"
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service

echo -e "************\e[36m install Mysql ************\e[0m"
dnf install mysql -y

echo -e "************\e[36m Load data mysql schema ************\e[0m"
mysql -h mysql-dev.nldevopsb01.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "************\e[36m Enable and Start Shipping Service ************\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping
