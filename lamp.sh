sleep 30 # Just to be safe

HOST_HTDOCS="/home/vagrant/shared/htdocs"
NODE_VERSION="12.14.0"

sudo apt update

echo "Installing nvm and node"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install $NODE_VERSION
nvm alias default $NODE_VERSION
nvm use $NODE_VERSION

echo "Done Installing nvm and node"

echo "Installing Docker"

# https://docs.docker.com/v17.12/config/daemon/systemd/#httphttps-proxy
# To avoid the error message chmod: cannot access '/etc/systemd/system/docker.service.d/http-proxy.conf': No such file or directory
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo touch /etc/systemd/system/docker.service.d/http-proxy.conf

sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

sudo apt update

apt-cache policy docker-ce

sudo apt install docker-ce -y

sudo systemctl status docker | cat

sudo usermod -aG docker ${USER}

newgrp docker

echo "Docker Installed"

echo "Installing mysql client"

sudo apt-get install -y mysql-client

echo "
[client]
default-character-set=utf8mb4
protocol=tcp

[mysql]
default-character-set=utf8mb4

[mysqld]
init-connect='SET NAMES utf8mb4'
character_set_server=utf8mb4
skip-character-set-client-handshake
collation_server=utf8mb4_unicode_ci
init_connect='SET collation_connection = utf8_unicode_ci'
" | sudo tee -a /etc/mysql/my.cnf

echo "Done installing mysql client"

echo "Setting Up Containers"

sudo docker run \
--restart always \
--network="host" \
-p 80:80 \
--name apache-server \
-v "$HOST_HTDOCS":/var/www/html \
-d php:7.4-apache

sudo docker run \
--restart always \
--network="host" \
--name mysql \
-p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=root \
-d mysql:latest \
--character-set-server=utf8mb4 \
--collation-server=utf8mb4_unicode_ci

sleep 30

sudo docker exec apache-server bash -c "docker-php-ext-install pdo_mysql"
sudo docker restart apache-server 
# PHP_VERSION=$(sudo docker exec my-apache-php-app bash -c "echo '<?= substr(phpversion(), 0, 3); ?>' | php")

echo "Done setting up containers"



echo $'
                          _                                 _     __
                         | |                               | |   / /
 _ __ ___   ___  ___  ___| |__ ________      ____ _ _ __ __| |  / / 
| \'_ ` _ \ / _ \/ _ \/ __| \'_ \______\ \ /\ / / _` | \'__/ _` | / /  
| | | | | |  __/  __/ (__| | | |      \ V  V / (_| | | | (_| |/ /   
|_| |_| |_|\___|\___|\___|_| |_|       \_/\_/ \__,_|_|  \__,_/_/    
' > /home/vagrant/.lamp.sh                                                                
                                                                    
echo '__/\\\_________________/\\\\\\\\\_____/\\\\____________/\\\\__/\\\\\\\\\\\\\___        
 _\/\\\_______________/\\\\\\\\\\\\\__\/\\\\\\________/\\\\\\_\/\\\/////////\\\_       
  _\/\\\______________/\\\/////////\\\_\/\\\//\\\____/\\\//\\\_\/\\\_______\/\\\_      
   _\/\\\_____________\/\\\_______\/\\\_\/\\\\///\\\/\\\/_\/\\\_\/\\\\\\\\\\\\\/__     
    _\/\\\_____________\/\\\\\\\\\\\\\\\_\/\\\__\///\\\/___\/\\\_\/\\\/////////____    
     _\/\\\_____________\/\\\/////////\\\_\/\\\____\///_____\/\\\_\/\\\_____________   
      _\/\\\_____________\/\\\_______\/\\\_\/\\\_____________\/\\\_\/\\\_____________  
       _\/\\\\\\\\\\\\\\\_\/\\\_______\/\\\_\/\\\_____________\/\\\_\/\\\_____________ 
        _\///////////////__\///________\///__\///______________\///__\///______________
        
' >> /home/vagrant/.lamp.sh

echo '
cat ~/.lamp.sh' >> /home/vagrant/.bashrc