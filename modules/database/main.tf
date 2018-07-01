############# RDS ##############

resource "aws_rds_cluster" "db-cluster" {
  cluster_identifier   = "pattern-db"
  database_name        = "${var.db_name}"
  master_username      = "${var.db_user}"
  master_password      = "${var.db_password}"
  db_subnet_group_name = "${var.db_subnet_group}"

  #availability_zones     = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}","${data.aws_availability_zones.available.names[2]}"]
  skip_final_snapshot    = true
  vpc_security_group_ids = ["${aws_security_group.rds-sg.id}"]
}

resource "aws_rds_cluster_instance" "cluster-instance1" {
  identifier     = "aurora-cluster-web-0"
  instance_class = "${var.db_instance_class}"

  #db_subnet_group_name = "${aws_db_subnet_group.rds_subnetgroup.name}"
  cluster_identifier = "${aws_rds_cluster.db-cluster.id}"

  tags {
    Name = "web-db-0"
  }
}

resource "aws_rds_cluster_instance" "cluster-instance2" {
  identifier     = "aurora-cluster-web-1"
  instance_class = "${var.db_instance_class}"

  #db_subnet_group_name = "${aws_db_subnet_group.rds_subnetgroup.name}"
  cluster_identifier = "${aws_rds_cluster.db-cluster.id}"

  tags {
    Name = "web-db-1"
  }
}

resource "aws_rds_cluster_instance" "cluster-instance3" {
  identifier     = "aurora-cluster-web-2"
  instance_class = "${var.db_instance_class}"

  #db_subnet_group_name = "${aws_db_subnet_group.rds_subnetgroup.name}"
  cluster_identifier = "${aws_rds_cluster.db-cluster.id}"

  tags {
    Name = "web-db-2"
  }
}

# security group
resource "aws_security_group" "rds-sg" {
  name   = "rds-sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    security_groups = ["${var.private_sg_id}"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "rds-sg-walid"
  }
}
