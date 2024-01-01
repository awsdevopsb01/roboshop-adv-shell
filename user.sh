source common.sh
script=$(realpath "$0")
script_path=$(dirname "$script")

func_setup_nodejs

echo -e "************\e[36m Create mongodb repo ************\e[0m"
cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "************\e[36m Install mongodb ************\e[0m"
dnf install mongodb-org-shell -y

echo -e "************\e[36m Load Mongodb data ************\e[0m"
mongo --host mongodb-dev.nldevopsb01.online </app/schema/user.js

echo -e "************\e[36m Create User Service ************\e[0m"
cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service

