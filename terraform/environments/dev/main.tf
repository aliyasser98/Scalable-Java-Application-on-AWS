provider "aws" {
  region = var.region
}
module "vpc" {
  source = "../../modules/vpc"
  environment = var.environment
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones = var.availability_zones
}
module "rds" {
  source = "../../modules/rds"
  environment = var.environment
  db_instance_class = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  subnet_ids = module.vpc.public_subnet_ids
  vpc_id = module.vpc.vpc_id
  depends_on = [ module.vpc ]
}
module "alb-asg" {
  source = "../../modules/alb-asg"
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.public_subnet_ids
  instance_type = var.instance_type
  ami_id        = var.ami_id
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity
  key_name = var.key_name
  user_data = var.user_data
  depends_on = [ module.rds ]
}
