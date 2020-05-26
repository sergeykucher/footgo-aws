
resource "aws_elb" "elb_result" {
  name    = "${var.elb_title}-elb"
  subnets = var.elb_subnets

  listener {
    lb_protocol       = "http"
    lb_port           = var.elb_lb_port
    instance_protocol = "http"
    instance_port     = var.elb_instance_port
  }

  security_groups = var.elb_security_groups

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:${var.elb_instance_port}"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 300
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "${var.elb_title} ELB"
  }
}
