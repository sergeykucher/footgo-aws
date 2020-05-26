
resource "aws_launch_configuration" "app_lc_result" {
  image_id                    = var.app_image_id
  instance_type               = var.app_instance_type
  name                        = "${var.app_title} app LC"
  iam_instance_profile        = var.app_iam_instance_profile
  enable_monitoring           = false
  user_data                   = var.app_user_data
  associate_public_ip_address = true
  root_block_device {
    volume_type = var.app_volume_type
    volume_size = var.app_volume_size
  }
  security_groups   = var.app_security_groups
  key_name          = var.key_name
  placement_tenancy = var.tenancy
}

resource "aws_autoscaling_group" "app_asg_result" {
  name                      = "${var.app_title} app ASG"
  launch_configuration      = aws_launch_configuration.app_lc_result.name
  desired_capacity          = var.app_asg_desired_capacity
  min_size                  = var.app_asg_min_size
  max_size                  = var.app_asg_max_size
  vpc_zone_identifier       = var.app_vpc_zone_identifier
  load_balancers            = var.app_load_balancers
  health_check_grace_period = 300
  health_check_type         = "EC2"
  termination_policies      = var.app_termination_policies
  tags = [
    {
      key                 = "Name",
      value               = "${var.app_title} app insatnce in ASG",
      propagate_at_launch = true
    }
  ]

}

resource "aws_autoscaling_policy" "app_as_policy_result" {
  name                      = "${var.app_title} app AS policy"
  autoscaling_group_name    = aws_autoscaling_group.app_asg_result.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.app_cpu_utilization
  }
}
