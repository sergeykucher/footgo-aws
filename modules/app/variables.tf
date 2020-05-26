variable "app_title" {}

variable "app_image_id" {}
variable "app_instance_type" {}
variable "app_iam_instance_profile" {}
variable "app_user_data" {}
variable "app_volume_type" {}
variable "app_volume_size" {}
variable "app_security_groups" {}

variable "key_name" {}
variable "tenancy" {}

variable "app_asg_desired_capacity" {}
variable "app_asg_min_size" {}
variable "app_asg_max_size" {}
variable "app_vpc_zone_identifier" {}
variable "app_load_balancers" {}
variable "app_termination_policies" {}
variable "app_cpu_utilization" {}
