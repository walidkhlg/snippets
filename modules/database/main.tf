############# RDS ##############

resource "aws_rds_cluster" "db-cluster" {
  cluster_identifier   = "pattern-db"
  database_name        = "${var.db_name}"
  master_username      = "${var.db_user}"
  master_password      = "${var.db_password}"
  db_subnet_group_name = "${aws_db_subnet_group.rds_subnetgroup.name}"
  skip_final_snapshot    = true
  vpc_security_group_ids = ["${aws_security_group.rds-sg.id}"]
  storage_encrypted = true
  kms_key_id = "${var.kms_key_id}"
}

resource "aws_rds_cluster_instance" "cluster-instance1" {
  identifier     = "aurora-cluster-web-0"
  instance_class = "${var.db_instance_class}"
  cluster_identifier = "${aws_rds_cluster.db-cluster.id}"

  tags {
    Name = "web-db-0"
  }
}

resource "aws_rds_cluster_instance" "cluster-instance2" {
  identifier     = "aurora-cluster-web-1"
  instance_class = "${var.db_instance_class}"
  cluster_identifier = "${aws_rds_cluster.db-cluster.id}"

  tags {
    Name = "web-db-1"
  }
}

resource "aws_rds_cluster_instance" "cluster-instance3" {
  identifier     = "aurora-cluster-web-2"
  instance_class = "${var.db_instance_class}"
  cluster_identifier = "${aws_rds_cluster.db-cluster.id}"

  tags {
    Name = "web-db-2"
  }
}
# subnet group for rds
resource "aws_db_subnet_group" "rds_subnetgroup" {
  name       = "rds_subnet_group"
  subnet_ids = ["subnet-4bfc1811", "subnet-3870aa5e}"]

  tags {
    Name = "rds-subnet-group"
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
