echo -e "************\e[36m Install Erlang ************\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "************\e[36m Setup RabbitMQ repo ************\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "************\e[36m Install RabbitMQ ************\e[0m"
dnf install rabbitmq-server -y

echo -e "************\e[36m Enable and Start RabbitMQ ************\e[0m"

systemctl enable rabbitmq-server
systemctl restart rabbitmq-server
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"