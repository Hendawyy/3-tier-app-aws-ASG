resource "aws_db_subnet_group" "dbsubnet" {
  name       = "db subnet"
  subnet_ids = var.private_subnets

}
resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  username               = "admin"
  password               = "admin"
  parameter_group_name   = "default.mysql8.0"
  multi_az               = true
  vpc_security_group_ids = [var.security_group_ids]
  db_subnet_group_name   = aws_db_subnet_group.dbsubnet.name
}
