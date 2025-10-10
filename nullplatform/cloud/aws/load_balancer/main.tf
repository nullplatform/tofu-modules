# ========================================
# INTERNAL ALB
# ========================================

resource "aws_lb" "internal" {
  name               = "k8s-nullplatform-internal"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_internal.id]
  subnets            = data.aws_subnets.private.ids

  enable_deletion_protection = false

  tags = {
    Name  = "k8s-nullplatform-internal"
    Group = "k8s-nullplatform-internal"
  }
}

resource "aws_security_group" "alb_internal" {
  name        = "alb-nullplatform-internal"
  description = "Security group for internal ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-nullplatform-internal"
  }
}

resource "aws_lb_target_group" "internal_default" {
  name        = "np-internal-default"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-499"
  }

  deregistration_delay = 10

  tags = {
    Name = "np-internal-default"
  }
}

resource "aws_lb_listener" "internal_http" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "internal_https" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404 scope not found or has not been deployed yet"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "internal_setup_host" {
  listener_arn = aws_lb_listener.internal_https.arn
  priority     = 100

  action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404 scope not found or has not been deployed yet"
      status_code  = "404"
    }
  }

  condition {
    host_header {
      values = ["setup.nullapps.io"]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

# ========================================
# PUBLIC (INTERNET-FACING) ALB
# ========================================

resource "aws_lb" "public" {
  name               = "k8s-nullplatform-internet-facing"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_public.id]
  subnets            = data.aws_subnets.public.ids

  enable_deletion_protection = false

  tags = {
    Name  = "k8s-nullplatform-internet-facing"
    Group = "k8s-nullplatform-internet-facing"
  }
}

resource "aws_security_group" "alb_public" {
  name        = "alb-nullplatform-public"
  description = "Security group for public ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-nullplatform-public"
  }
}

resource "aws_lb_target_group" "public_default" {
  name        = "np-public-default"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-499"
  }

  deregistration_delay = 10

  tags = {
    Name = "np-public-default"
  }
}

resource "aws_lb_listener" "public_http" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "public_https" {
  load_balancer_arn = aws_lb.public.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404 scope not found or has not been deployed yet"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "public_setup_host" {
  listener_arn = aws_lb_listener.public_https.arn
  priority     = 100

  action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404 scope not found or has not been deployed yet"
      status_code  = "404"
    }
  }

  condition {
    host_header {
      values = ["setup.nullapps.io"]
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
