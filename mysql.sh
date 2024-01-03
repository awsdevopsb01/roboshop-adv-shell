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


func_setup_header "Setup Mysql version"
dnf module disable mysql -y
cp $script_path/mysql.repo /etc/yum.repos.d/mysql.repo &>> $log_path
func_status_check $?

func_setup_header "Install Mysql"
dnf install mysql-community-server -y &>> $log_path
func_status_check $?

func_setup_header "Enable and Start Mysql"
systemctl enable mysqld &>> $log_path
func_status_check $?
systemctl restart mysqld &>> $log_path
func_status_check $?

func_setup_header "Reset Mysql Default Password"
mysql_secure_installation --set-root-pass RoboShop@1 &>> $log_path
func_status_check $?