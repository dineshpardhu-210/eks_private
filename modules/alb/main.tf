resource "aws_lb" "this" {
  name = var.alb_name
  internal = true
  load_balancer_type = "application"
  subnets = var.subnets
  security_groups = var.security_group_ids
  tags = var.tags
}

resource "aws_lb_target_group" "this" {
  name = "tg-private"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    path = "/"
    interval = 30
    matcher = "200-399"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not configured"
      status_code = "200"
    }
  }
}

