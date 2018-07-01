output "subnet_ids" {
  value = [
    "${aws_subnet.public1_subnet.id}",
    "${aws_subnet.public2_subnet.id}",
    "${aws_db_subnet_group.rds_subnetgroup.name}",
  ]
}

output "vpc_id" {
  value = "${aws_vpc.pattern1.id}"
}
