resource "aws_route53_zone" "private" {
  name = "cptc.com"

  vpc {
    vpc_id = "${aws_vpc.default.id}"
  }
}

resource "aws_route53_record" "salt" {
  zone_id = "${aws_route53_zone.private.id}"
  name = "salt.${aws_route53_zone.private.name}"
  type = "A"
  ttl = "300"

  records = [
    "10.0.0.5"
  ]
}
