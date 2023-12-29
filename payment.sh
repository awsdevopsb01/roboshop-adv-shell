source common.sh
script=$(realpath "$0")
script_path=$(dirname "$script")

echo -e "************\e[36m Install Python ************\e[0m"
dnf install python36 gcc python3-devel -y

echo -e "************\e[36m Create a Functional User ************\e[0m"
useradd ${func_user}

echo -e "************\e[36m Create an App Directory ************\e[0m"
rm -rf /app
mkdir /app
echo -e "************\e[36m Download App Content ************\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip

echo -e "************\e[36m Extract App Content ************\e[0m"
cd /app
unzip /tmp/payment.zip

echo -e "************\e[36m Install Dependencies ************\e[0m"
pip3.6 install -r requirements.txt

echo -e "************\e[36m Copy Payment Service ************\e[0m"
cp script_path/payment.service /etc/systemd/system/payment.service

echo -e "************\e[36m Enable and Start Payment Service ************\e[0m"

systemctl daemon-reload
systemctl enable payment
systemctl restart payment