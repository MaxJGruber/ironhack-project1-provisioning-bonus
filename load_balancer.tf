########################################
# Load Balancer + Target Group
########################################
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.alb_sg.id]
  tags = {
    Name = "app-lb"
  }
}

resource "aws_lb_target_group" "frontend_80" {
  name     = "frontend-80"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
  tags = {
    Name = "vote-tg"
  }
}

resource "aws_lb_target_group" "frontend_81" {
  name     = "frontend-81"
  port     = 81
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    path                = "/result"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
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
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_80.arn
  }
}

resource "aws_lb_listener_rule" "result_path" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_81.arn
  }

  condition {
    path_pattern {
      values = ["/result", "/result/*"]
    }
  }
}

# Target group attachments
resource "aws_lb_target_group_attachment" "frontend_1_80" {
  target_group_arn = aws_lb_target_group.frontend_80.arn
  target_id        = aws_instance.frontend_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "frontend_2_80" {
  target_group_arn = aws_lb_target_group.frontend_80.arn
  target_id        = aws_instance.frontend_2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "frontend_1_81" {
  target_group_arn = aws_lb_target_group.frontend_81.arn
  target_id        = aws_instance.frontend_1.id
  port             = 81
}

resource "aws_lb_target_group_attachment" "frontend_2_81" {
  target_group_arn = aws_lb_target_group.frontend_81.arn
  target_id        = aws_instance.frontend_2.id
  port             = 81
}