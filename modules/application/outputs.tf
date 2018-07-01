output "logs_bucket_name" {
  value = "${aws_s3_bucket.logs_bucket.id}"
}

output "private_sg_id" {
  value = "${aws_security_group.sg-private.id}"
}

output "elb_address" {
  value = "${aws_elb.web-elb.dns_name}"
}
