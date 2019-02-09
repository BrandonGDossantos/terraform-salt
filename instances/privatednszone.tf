resource "aws_route53_zone" "private" {
  name = "cptc.com"

  vpc {
    vpc_id = "${var.vpc_id}"
  }
}