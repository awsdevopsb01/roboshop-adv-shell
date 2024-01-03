script=$(realpath "$0")
script_path=$(dirname "$script")
func_user="roboshop"
component="$1"
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

func_load_schema() {
 if [ "$load_schema" == "mongo" ]; then
  func_setup_header "Copy Mongodb repo"
  cp "$script_path"/mongo.repo /etc/yum.repos.d/mongo.repo &>> $log_path
  func_status_check $?

  func_setup_header "Install mongodb"
  dnf install mongodb-org-shell -y &>> /tmp/roboshop.log
  func_status_check $?

  func_setup_header "Load Mongodb"
  mongo --host mongodb-dev.nldevopsb01.online </app/schema/"${component}".js &>> $log_path
  func_status_check $?
 fi
 if [ "$load_schema" == "mysql" ]; then
  func_setup_header "Install Mysql"
  dnf install mysql -y &>> $log_path
  func_status_check $?

  func_setup_header "Load Mysql Schema"
  mysql -h mysql-dev.nldevopsb01.online -uroot -pRoboShop@1 < /app/schema/"${component}".sql &>> $log_path
  func_status_check $?
 fi
}

func_setup_nodejs() {
 func_setup_header "Setup NodeJs Version"
 dnf module disable nodejs -y &>> $log_path
 dnf module enable nodejs:18 -y &>> $log_path
 func_status_check $?

 func_setup_header "Install NodeJs "
 dnf install nodejs -y &>> $log_path
 func_status_check $?

 func_app_setup

 func_setup_header "Install Dependencies "
 npm install &>> $log_path
 func_status_check $?

 func_load_schema
 func_start_systemd
}

func_java_setup() {

  func_setup_header "Install Maven"
  dnf install maven -y &>> $log_path
  func_status_check $?

  func_app_setup

  func_setup_header "Install Dependencies"
  mvn clean package &>> $log_path
  func_status_check $?

  func_setup_header "Move Shipping.jar file"
  mv target/shipping-1.0.jar shipping.jar &>> $log_path
  func_status_check $?

  func_load_schema
  func_start_systemd
}

 func_app_setup() {
  func_setup_header "Create a Functional User "
  id ${func_user} &>> $log_path
  if [ "$?" -ne 0 ]; then
   useradd ${func_user} &>> $log_path
  fi
  func_status_check $?

  func_setup_header "Create Application Directory "
  rm -rf /app
  mkdir /app &>> $log_path
  func_status_check $?

  func_setup_header "Download Application Content "
  curl -L -o /tmp/"${component}".zip https://roboshop-artifacts.s3.amazonaws.com/"${component}".zip &>> $log_path
  func_status_check $?

  func_setup_header "Extract Application Content "
  cd /app
  unzip /tmp/"${component}".zip &>> $log_path
  func_status_check $?
 }

 func_start_systemd() {
    func_setup_header "Copy Application Service "
    cp "$script_path"/"${component}".service /etc/systemd/system/"${component}".service &>> $log_path
    func_status_check $?

    func_setup_header "Enable and Start Application Service "
    systemctl daemon-reload &>> $log_path
    func_status_check $?
    systemctl enable "${component}" &>> $log_path
    func_status_check $?
    systemctl restart "${component}" &>> $log_path
    func_status_check $?
 }

 func_python_setup() {
   func_setup_header "Install Python"
   dnf install python36 gcc python3-devel -y

   func_app_setup

   func_setup_header "Install Dependencies"
   pip3.6 install -r requirements.txt

   func_start_systemd
 }