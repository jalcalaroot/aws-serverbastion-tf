### ingresar credenciales
variable "access_key" {}
variable "secret_key" {}
variable "region" {}
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

### ingresar variables
variable "vpc_id" {
  type        = "string"
  description = "indicar el vpc_id"
}
variable "subnet_id" {
  type        = "string"
  description = "indicar el subnet_id"
}
variable "key_name" {
  type        = "string"
  description = "indicar el key_name"
}

#-----------------------------------------------------------
#SG
resource "aws_security_group" "bastion-sg" {
  name = "bastion-sg"
  description = "bastion-sg"
  vpc_id = "${var.vpc_id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
# SSH
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
# http
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
# https
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
# Kafka Manager
  ingress {
    from_port = 9000
    to_port = 9000
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
# Kafka Topics
  ingress {
    from_port = 9001
    to_port = 9001
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
# 8080
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
# 81
  ingress {
    from_port = 81
    to_port = 81
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
# 8082: Ejemplo Para consumo interno dentro de la vpc >> 10.0.0.0/16
  }
  ingress {
    from_port = 8082
    to_port = 8082
    protocol = "tcp"
    cidr_blocks = [
      "10.0.0.0/16"]
  }


  tags = {
    env  = "terraform"
    name = "bastion-sg"
  }
}
#--------------------------------------------------------
resource "aws_instance" "bastion" {
  ami = "ami-04681a1dbd79675a5"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.bastion-sg.id}"]
  subnet_id = "${var.subnet_id}"
  instance_type = "t2.small"
  private_ip = "10.0.136.70"
  user_data = "${file("deploy.sh")}"
  root_block_device {
  volume_type = "gp2"
  volume_size = 100
  }

  tags = {
    Name = "bastion"
    env = "terraform"
  }
}

resource "aws_eip" "bastion" {
  vpc = true

  instance                  = "${aws_instance.bastion.id}"
  associate_with_private_ip = "10.0.136.70"
}

#---------------------------------------------------------

