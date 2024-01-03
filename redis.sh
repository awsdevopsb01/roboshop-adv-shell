script=$(realpath "$0")
script_path=$(dirname "$script")
log_path=/tmp/roboshop.log

func_setup_header() {
  echo -e "************\e[36m $1 ************\e[0m"
  echo -e "************\e[36m $1 ************\e[0m" &>> $log_path
}

func_status_check() {
  if [ "$1" -ne 0 ]; then
      echo -e "\e[31m FAILURE \e[0m" "$1"
      exit 1
  else
    echo -e "\e[32m SUCCESS \e[0m"
  fi
}

func_setup_header "Setup Redis Package Manager"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $log_path
func_status_check $?

func_setup_header "Install Redis"
dnf module enable redis:remi-6.2 -y &>> $log_path
dnf install redis -y &>> $log_path &>> $log_path
func_status_check $?

func_setup_header "Update listener Ip"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf &>> $log_path
func_status_check $?

func_setup_header "Enable & Start"
systemctl enable redis &>> $log_path
systemctl restart redis &>> $log_path
func_status_check $?