#!/bin/bash
sudo yum -y  update && sudo yum -y upgrade 
sudo yum install nano curl wget zip git vim htop -y
# Install docker
sudo yum install docker -y
yum install docker -y
sudo usermod -a -G docker ec2-user
# Install docker composer
# download the docker compose binary
curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` > ./docker-compose
# mv docker-compose binary to usr/bin folder
sudo mv ./docker-compose /usr/bin/docker-compose
# make docker-compose binary executable
sudo chmod +x /usr/bin/docker-compose
# start the docker service
sudo service docker start
# add ec2-user to the docker group to lose the sudo command when using docker
sudo usermod -a -G docker ec2-user
sudo mkdir /home/ec2-user/nginx-compose
cat <<EOF >/home/ec2-user/nginx-compose/docker-compose.yml
nginx:
  image: nginx
  ports:
    - "80:80"
EOF
sudo chown ec2-user:ec2-user /home/ec2-user/nginx-compose/docker-compose.yml
/usr/bin/docker-compose -f /home/ec2-user/nginx-compose/docker-compose.yml up -d
