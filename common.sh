script=$(realpath "$0")
script_path=$(dirname "$script")
func_user="roboshop"
component="$1"

func_setup_header() {
  echo -e "************\e[36m $1 ************\e[0m"
  echo -e "************\e[36m $1 ************\e[0m" &>> /tmp/roboshop.log
}

func_status_check() {
  if [ "$1" -ne 0 ]; then
      echo -e "\e[31m FAILURE \e[0m" $1
      exit 1
  else
    echo -e "\e[32m SUCCESS \e[0m"
  fi

}

func_load_schema() {
 if [ "$load_schema" == "mongo" ]; then
  func_setup_header "Copy Mongodb repo"
  cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> /tmp/roboshop.log
  func_status_check $?

  func_setup_header "Install mongodb"
  dnf install mongodb-org-shell -y &>> /tmp/roboshop.log
  func_status_check $?

  func_setup_header "Load Mongodb"
  mongo --host mongodb-dev.nldevopsb01.online </app/schema/"${component}".js &>> /tmp/roboshop.log
  func_status_check $?

 elif [ "$load_schema" == "mysql" ]; then
  func_setup_header "Install Mysql"
  dnf install mysql -y &>> /tmp/roboshop.log
  func_status_check $?

  func_setup_header "Load Mysql Schema"
  mysql -h mysql-dev.nldevopsb01.online -uroot -pRoboShop@1 < /app/schema/"${component}".sql &>> /tmp/roboshop.log
  func_status_check $?
 fi
}

func_setup_nodejs() {
 func_setup_header "Setup NodeJs Version"
 dnf module disable nodejs -y &>> /tmp/roboshop.log
 dnf module enable nodejs:18 -y &>> /tmp/roboshop.log
 func_status_check $?

 func_setup_header "Install NodeJs "
 dnf install nodejs -y &>> /tmp/roboshop.log
 func_status_check $?

 func_app_setup

 func_setup_header "Install Dependencies "
 npm install &>> /tmp/roboshop.log
 func_status_check $?

 func_load_schema
 func_start_systemd
}

func_java_setup() {

  func_setup_header "Install Maven"
  dnf install maven -y &>> /tmp/roboshop.log
  func_status_check $?

  func_app_setup

  func_setup_header "Install Dependencies"
  mvn clean package &>> /tmp/roboshop.log
  func_status_check $?

  func_setup_header "Move Shipping.jar file"
  mv target/shipping-1.0.jar shipping.jar &>> /tmp/roboshop.log
  func_status_check $?

  func_load_schema
  func_start_systemd
}

 func_app_setup() {
  func_setup_header "Create a Functional User "
  useradd ${func_user} &>> /tmp/roboshop.log
  func_status_check $?

  func_setup_header "Create Application Directory "
  rm -rf /app
  mkdir /app &>> /tmp/roboshop.log
  func_status_check $?

  func_setup_header "Download Application Content "
  curl -L -o /tmp/"${component}".zip https://roboshop-artifacts.s3.amazonaws.com/"${component}".zip &>> /tmp/roboshop.log
  func_status_check $?

  func_setup_header "Extract Application Content "
  cd /app
  unzip /tmp/"${component}".zip &>> /tmp/roboshop.log
  func_status_check $?
 }

 func_start_systemd() {
    func_setup_header "Copy Application Service "
    cp "$script_path"/"${component}".service /etc/systemd/system/"${component}".service &>> /tmp/roboshop.log
    func_status_check $?

    func_setup_header "Enable and Start Application Service "
    systemctl daemon-reload &>> /tmp/roboshop.log
    func_status_check $?
    systemctl enable "${component}" &>> /tmp/roboshop.log
    func_status_check $?
    systemctl restart "${component}" &>> /tmp/roboshop.log
    func_status_check $?
 }