############# launch config ######
# instance profile

resource "aws_iam_instance_profile" "web_s3_profile" {
  name = "web_s3_profile"
  role = "${var.iam_role}"
}

data "template_file" "userdata" {
  template = "${file("./files/userdata.web")}"

  vars {
    bucket_name = "webapp-20180702142715619000000002"
    dbhost      = "${var.dbhost}"
    dbuser      = "${var.db_user}"
    dbpass      = "${var.db_password}"
    dbname      = "${var.db_name}"
    dbreadname  = "${var.dbread}"
    logs_bucket = "web-ec2-logs-20180702142536374800000001"
  }
}

#####launch configuration
resource "aws_launch_configuration" "web-lc" {
  name_prefix          = "web-lc-"
  image_id             = "${var.launch_ami}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.sg-private.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.web_s3_profile.id}"

  user_data = "${data.template_file.userdata.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

################### Autoscaling Group###############

resource "aws_autoscaling_group" "web-asg" {
  max_size                  = "${var.asg_max}"
  min_size                  = "${var.asg_min}"
  desired_capacity          = "${var.asg_capacity}"
  health_check_grace_period = "${var.asg_grace}"
  health_check_type         = "ELB"
  force_delete              = true
  load_balancers            = ["${aws_elb.web-elb.id}"]
  vpc_zone_identifier       = ["${var.subnet_ids["public1"]}", "${var.subnet_ids["public2"]}"]

  launch_configuration = "${aws_launch_configuration.web-lc.name}"

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "asg-web"
  }
}

####### Security Groups ####################

resource "aws_security_group" "sg-elb" {
  name   = "allow_web"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "sg-elb"
  }
}

resource "aws_security_group" "sg-private" {
  name   = "sg_private-walid"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["${aws_security_group.sg-elb.id}"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "sg_private"
  }
}

##################### scale policy ##############
resource "aws_autoscaling_policy" "cpu-policy" {
  name                   = "cpu-policy"
  autoscaling_group_name = "${aws_autoscaling_group.web-asg.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm" {
  alarm_name          = "cpu-alarm"
  alarm_description   = "cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.web-asg.name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.cpu-policy.arn}"]
}

# scale down alarm
resource "aws_autoscaling_policy" "cpu-policy-scaledown" {
  name                   = "cpu-policy-scaledown"
  autoscaling_group_name = "${aws_autoscaling_group.web-asg.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm-scaledown" {
  alarm_name          = "cpu-alarm-scaledown"
  alarm_description   = "cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.web-asg.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.cpu-policy-scaledown.arn}"]
}

################ elb #############

resource "aws_elb" "web-elb" {
  name            = "web-elb"
  subnets         = ["subnet-dceb0f86", "subnet-1c71ab7a"]
  security_groups = ["${aws_security_group.sg-elb.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = "2"
    interval            = "30"
    target              = "TCP:80"
    timeout             = "3"
    unhealthy_threshold = "2"
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "web-elb-walid"
  }
}

#################### s3  bucket for logs #######################
resource "aws_s3_bucket" "logs_bucket" {
  bucket_prefix = "web-ec2-logs-"
  acl           = "private"
  server_side_encryption_configuration {
  rule {
  apply_server_side_encryption_by_default {
    kms_master_key_id = "${var.kms_key_id}"
    sse_algorithm = "aws:kms"
      }
    }
  }
  tags {
    Name = "Instance_log_bucket"
  }
}

data "template_file" "rendered_log_script" {
  template = "${file("./files/log.sh")}"
  vars {
    logs_bucket = "${aws_s3_bucket.logs_bucket.id}"
  }
}

resource "aws_s3_bucket_object" "logs_script" {
  bucket  = "web-ec2-logs-20180702142536374800000001"
  key     = "log.sh"
  source = "${data.template_file.rendered_log_script.rendered}"
  kms_key_id = "${var.kms_key_id}"
  tags {
    Name = "logging_script"
  }
}
#### s3 bucket for application code ####
resource "aws_s3_bucket" "app_bucket" {
  bucket_prefix = "webapp-"
  acl           = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${var.kms_key_id}"
        sse_algorithm = "aws:kms"
        }
      }
    }
    tags {
      Name = "Application code bucket"
    }
  }



resource "aws_s3_bucket_object" "app_package" {
  bucket  = "webapp-20180702142715619000000002"
  key     = "App.zip"
  source = "${file("./files/App.zip")}"
  kms_key_id = "${var.kms_key_id}"
  tags {
    Name = "Application package"
  }
}
