########################################
# Load Balancer + Target Group
########################################
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_a_2.id]
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name = "app-lb"
  }
}

resource "aws_lb_target_group" "vote_tg" {
  name        = "vote-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  tags = {
    Name = "vote-tg"
  }
}

resource "aws_lb_target_group" "result_tg" {
  name        = "result-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main_vpc.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  tags = {
    Name = "result-tg"
  }
}

# ALB Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "NOT FOUND"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "vote_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vote_tg.arn
  }
  condition {
    path_pattern {
      values = ["/vote"]
    }
  }
}

resource "aws_lb_listener_rule" "result_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.result_tg.arn
  }
  condition {
    path_pattern {
      values = ["/result"]
    }
  }
}


# Register EC2 Instances
resource "aws_lb_target_group_attachment" "tg_attachment_vote" {
  target_group_arn = aws_lb_target_group.vote_tg.arn
  target_id        = aws_instance.instance-a-frontend.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_attachment_result" {
  target_group_arn = aws_lb_target_group.result_tg.arn
#   target_id        = aws_instance.instance-a-frontend.id
  port             = 80
}

########################################
# Output
########################################
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_lb.dns_name
}
