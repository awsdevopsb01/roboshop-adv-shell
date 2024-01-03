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

func_setup_header "Install Erlang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $log_path
func_status_check $?

func_setup_header "Setup RabbitMQ repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $log_path
func_status_check $?

func_setup_header "Install RabbitMQ"
dnf install rabbitmq-server -y &>> $log_path
func_status_check $?

func_setup_header "Enable and Start RabbitMQ"

systemctl enable rabbitmq-server &>> $log_path
func_status_check $?
systemctl restart rabbitmq-server &>> $log_path
func_status_check $?

func_setup_header "Add RabbitMQ User and set permissions"
rabbitmqctl add_user roboshop roboshop123 &>> $log_path
func_status_check $?
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $log_path
func_status_check $?