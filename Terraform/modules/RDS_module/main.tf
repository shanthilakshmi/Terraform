resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = [var.private_app_subnet_az1_id, var.private_app_subnet_az2_id]

  tags = {
    Name = "db_subnet_group"
  }
}

resource "aws_db_instance" "Demo_RDS" {

  engine            = var.engine_name
  engine_version    = var.engine_version
  instance_class    = var.instance_type
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
  availability_zone    = var.availability_zone
  allocated_storage = 10
  username	    = var.user_name
  password	    = var.passwd
  skip_final_snapshot = true

  tags = {
  Name =  "${var.project_name}-${var.environment}"
  Environment = var.environment
  }

}
