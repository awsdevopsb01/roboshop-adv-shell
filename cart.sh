echo -e "************\e[36m Setup NodeJs Version ************\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "************\e[36m Install NodeJs ************\e[0m"
dnf install nodejs -y

echo -e "************\e[36m Create a Functional User ************\e[0m"
useradd roboshop

echo -e "************\e[36m Create App Directory ************\e[0m"
rm -rf /app
mkdir /app

echo -e "************\e[36m Download App Content ************\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip

echo -e "************\e[36m Extract App Content ************\e[0m"
cd /app
unzip /tmp/cart.zip

echo -e "************\e[36m Install Dependencies ************\e[0m"
npm install

echo -e "************\e[36m Copy Cart Service ************\e[0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service

echo -e "************\e[36m Enable and Start Cart Service ************\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart

