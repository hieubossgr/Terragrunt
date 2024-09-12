resource "aws_rds_cluster" "this" {
  cluster_identifier = var.cluster_identifier
  availability_zones = var.availability_zone
  engine             = var.engine_aurora
  engine_version     = var.engine_version
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  skip_final_snapshot = true

  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  tags = {
    Name = var.cluster_identifier
  }
}

resource "aws_rds_cluster_instance" "writer" {
  count              = var.rds_write_number
  identifier         = "${var.cluster_identifier}-writer-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  publicly_accessible = false

  tags = {
    Name = "${var.cluster_identifier}-writer-${count.index}"
  }
}

resource "aws_rds_cluster_instance" "reader" {
  count              = var.rds_read_number
  identifier         = "${var.cluster_identifier}-reader-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  publicly_accessible = false

  tags = {
    Name = "${var.cluster_identifier}-reader-${count.index}"
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.cluster_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.cluster_identifier}-subnet-group"
  }
}

resource "aws_appautoscaling_target" "reader" {
  max_capacity       = var.reader_max_capacity
  min_capacity       = var.reader_min_capacity
  resource_id        = "cluster:${aws_rds_cluster.this.id}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}

resource "aws_appautoscaling_policy" "replicas" {
  name               = "cpu-auto-scaling"
  service_namespace  = aws_appautoscaling_target.reader.service_namespace
  scalable_dimension = aws_appautoscaling_target.reader.scalable_dimension
  resource_id        = aws_appautoscaling_target.reader.resource_id
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageCPUUtilization"
    }

    target_value       = 75
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}