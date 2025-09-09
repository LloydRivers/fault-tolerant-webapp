resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "web-sg" }
}

resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt-"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd

    cat <<'EOT' > /var/www/html/index.html
    ${file("${path.module}/index.html")}
    EOT
    EOF
  )
}

resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  target_group_arns    = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier       = var.private_subnet_ids
  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "web-asg-instance"
    propagate_at_launch = true
  }
}
/*

*/