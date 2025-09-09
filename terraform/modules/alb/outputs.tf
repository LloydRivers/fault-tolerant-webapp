output "alb_id" {
  value = aws_lb.web_alb.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.web_tg.arn
}

