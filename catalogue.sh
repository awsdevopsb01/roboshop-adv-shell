
script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh

func_setup_nodejs catalogue

echo -e "************\e[36m Copy Mongodb repo *********\e[0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "************\e[36m Install mongodb *********\e[0m"
dnf install mongodb-org-shell -y

echo -e "************\e[36m Load Mongodb *********\e[0m"
mongo --host mongodb-dev.nldevopsb01.online </app/schema/catalogue.js

systemctl restart catalogue