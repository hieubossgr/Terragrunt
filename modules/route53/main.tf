resource "aws_route53_zone" "hblabs" {
  name = var.name
}

resource "aws_route53_record" "alb" {
  zone_id = aws_route53_zone.hblabs.zone_id
  name    = var.name
  type    = "A"
  alias {
    name                   = var.dns_name
    zone_id                = var.zone_id
    evaluate_target_health = true
  }
}