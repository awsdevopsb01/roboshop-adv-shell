script=$(realpath "$0")
script_path=$(dirname "$script")
func_user="roboshop"
component="$1"

func_setup_header() {
  echo -e "************\e[36m $1 ************\e[0m"
}

func_load_schema() {
 if [ "$load_schema" == "mongo" ]; then
  func_setup_header "Copy Mongodb repo"
  cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

  func_setup_header "Install mongodb"
  dnf install mongodb-org-shell -y

  func_setup_header "Load Mongodb"
  mongo --host mongodb-dev.nldevopsb01.online </app/schema/"${component}".js

 elif [ "$load_schema" == "mysql" ]; then
  func_setup_header "Install Mysql"
  dnf install mysql -y

  func_setup_header "Load Mysql Schema"
  mysql -h mysql-dev.nldevopsb01.online -uroot -pRoboShop@1 < /app/schema/"${component}".sql
 fi
}

func_setup_nodejs() {
 func_setup_header "Setup NodeJs Version"
 dnf module disable nodejs -y
 dnf module enable nodejs:18 -y

 func_setup_header "Install NodeJs "
 dnf install nodejs -y

 func_app_setup

 func_setup_header "Install Dependencies "
 npm install

 func_load_schema
 func_start_systemd
}

func_java_setup() {

  func_setup_header "Install Maven"
  dnf install maven -y

  func_app_setup

  func_setup_header "Install Dependencies"
  mvn clean package

  func_setup_header "Move Shipping.jar file"
  mv target/shipping-1.0.jar shipping.jar

  func_load_schema
  func_start_systemd
}

 func_app_setup() {
  func_setup_header "Create a Functional User "
  useradd ${func_user}
  if [ "$?" -ne 0 ]; then
    exit 1
  fi

  func_setup_header "Create Application Directory "
  rm -rf /app
  mkdir /app

  func_setup_header "Download Application Content "
  curl -L -o /tmp/"${component}".zip https://roboshop-artifacts.s3.amazonaws.com/"${component}".zip

  func_setup_header "Extract Application Content "
  cd /app
  unzip /tmp/"${component}".zip
 }

 func_start_systemd() {
    func_setup_header "Copy Application Service "
    cp "$script_path"/"${component}".service /etc/systemd/system/"${component}".service

    func_setup_header "Enable and Start Application Service "
    systemctl daemon-reload
    systemctl enable "${component}"
    systemctl restart "${component}"
 }