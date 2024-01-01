script=$(realpath "$0")
script_path=$(dirname "$script")
func_user="roboshop"
component="$1"

func_setup_header() {
  echo -e "************\e[36m $1 ************\e[0m"
}

func_setup_nodejs() {
 func_setup_header "Setup NodeJs Version"
 dnf module disable nodejs -y
 dnf module enable nodejs:18 -y

 func_setup_header "Install NodeJs "
dnf install nodejs -y

 func_setup_header "Create a Functional User "
useradd ${func_user}

func_setup_header "Create App Directory "
rm -rf /app
mkdir /app

func_setup_header "Download App Content "
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

func_setup_header "Extract App Content "
cd /app
unzip /tmp/${component}.zip

func_setup_header "Install Dependencies "
npm install

func_setup_header "Copy Cart Service "
cp $script_path/cart.service /etc/systemd/system/cart.service

func_setup_header "Enable and Start Cart Service "
systemctl daemon-reload
systemctl enable cart
systemctl restart cart

}