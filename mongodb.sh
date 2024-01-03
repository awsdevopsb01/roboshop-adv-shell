script=$(realpath "$0")
script_path=$(dirname "$script")
log_path=/tmp/roboshop.log

func_setup_header() {
  echo -e "************\e[36m $1 ************\e[0m"
  echo -e "************\e[36m $1 ************\e[0m" &>> $log_path
}

func_status_check() {
  if [ "$1" -ne 0 ]; then
      echo -e "\e[31m FAILURE \e[0m" $1
      exit 1
  else
    echo -e "\e[32m SUCCESS \e[0m"
  fi
}


func_setup_header "Copy Mongodb repo"
cp "$script_path"/mongo.repo /etc/yum.repos.d/mongo.repo &>> $log_path
func_status_check $?

func_setup_header "Install Mongodb"
dnf install mongodb-org -y &>> $log_path
func_status_check $?

func_setup_header "Update config file to listen from all Servers"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>> $log_path
func_status_check $?

func_setup_header "Enable & Start Mongodb Service"
systemctl enable mongod &>> $log_path
func_status_check $?
systemctl restart mongod &>> $log_path
func_status_check $?