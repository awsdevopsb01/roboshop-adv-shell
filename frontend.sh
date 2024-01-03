script=$(realpath "$0")
script_path=$(dirname "$script")
source "${script_path}"/common.sh


func_setup_header "Install NGINX "
dnf install nginx -y &>> $log_path

func_setup_header "Enable & Start NGINX"
systemctl enable nginx &>> $log_path
func_status_check $?
systemctl start nginx &>> $log_path
func_status_check $?

func_setup_header "Remove default html files"
rm -rf /usr/share/nginx/html/* &>> $log_path
func_status_check $?

func_setup_header "Download frontend code"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>> $log_path
func_status_check $?
cd /usr/share/nginx/html

func_setup_header "Unzip frontend files"
unzip /tmp/frontend.zip &>> $log_path
func_status_check $?

func_setup_header "Copy Roboshop Config file"
cp $script_path/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $log_path
func_status_check $?

func_setup_header "ReStart NGINX"
systemctl restart nginx &>> $log_path
func_status_check $?