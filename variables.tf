variable "project_name" {
  default = "footgo"
}

variable "region" {
  default = "eu-central-1"
}
variable "ssh_cidr_block" {
  default = "109.251.31.5/32"
}

variable "http_8080_cidr_block" {
  default = "0.0.0.0/0"
}

variable "destination_cidr_block" {
  default = "0.0.0.0/0"
}

variable "db_name" {
  default = "footgo"
}

variable "db_username" {
  default = "root"
}

variable "db_password" {
  default = "pwdpwdpwd"
}

variable "key_name" {
  default = "aws-keys"
}

variable "app_image_id" {
  default = "ami-0122f9a5047d9dec1"
}
