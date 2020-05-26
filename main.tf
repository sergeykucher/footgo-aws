# Terraform state will be stored in S3
terraform {
  backend "s3" {
    bucket = "footgo"
    key    = "terraform-footgo/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.region
}

module "footgo_vpc" {
  source = "./modules/vpc"

  vpc_title                      = var.project_name
  vpc_cidr_block                 = "172.22.0.0/16"
  public_subnets_az              = ["${var.region}b", "${var.region}c"]
  public_subnets_vpc_cidr_block  = ["172.22.2.0/24", "172.22.102.0/24"]
  private_subnets_az             = ["${var.region}b", "${var.region}c"]
  private_subnets_vpc_cidr_block = ["172.22.12.0/24", "172.22.112.0/24"]

  ssh_cidr_block         = var.ssh_cidr_block
  http_8080_cidr_block   = var.http_8080_cidr_block
  destination_cidr_block = var.destination_cidr_block
}

module "footgo_db" {
  source = "./modules/db"

  db_title = var.project_name
  db_subnet_ids = [module.footgo_vpc.private_subnet_a_id,
  module.footgo_vpc.private_subnet_b_id]

  db_engine            = "mysql"
  db_engine_version    = "5.7"
  db_identifier        = "${var.project_name}-db"
  db_instance_class    = "db.t2.micro"
  db_allocated_storage = 20
  db_storage_type      = "gp2"
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
}

module "footgo_iam" {
  source = "./modules/iam"

  assume_role_policy = file("./files/ec2_assume_role.json")
  policy             = file("./files/s3_read_only_policy.json")
}

module "footgo_elb" {
  source = "./modules/elb"

  elb_title         = var.project_name
  elb_subnets       = [module.footgo_vpc.public_subnet_a_id, module.footgo_vpc.public_subnet_b_id]
  elb_lb_port       = 80
  elb_instance_port = 8080
  elb_security_groups = [module.footgo_vpc.default_security_group_id,
  module.footgo_vpc.http_8080_security_group_id]
}

module "footgo_app" {
  source = "./modules/app"

  app_title                = var.project_name
  app_image_id             = var.app_image_id
  app_instance_type        = "t2.micro"
  app_iam_instance_profile = module.footgo_iam.es2_s3_read_only_profile_name
  app_user_data            = file("./files/app_user_data.sh")
  app_volume_type          = "gp2"
  app_volume_size          = 8
  app_security_groups = [module.footgo_vpc.default_security_group_id,
    module.footgo_vpc.ssh_security_group_id,
  module.footgo_vpc.http_8080_security_group_id]

  key_name = var.key_name
  tenancy  = "default"

  app_asg_desired_capacity = 0
  app_asg_min_size         = 0
  app_asg_max_size         = 0
  app_vpc_zone_identifier  = [module.footgo_vpc.public_subnet_a_id, module.footgo_vpc.public_subnet_b_id]
  app_load_balancers       = [module.footgo_elb.elb_name]
  app_termination_policies = ["OldestInstance"]
  app_cpu_utilization      = 40.0
}

