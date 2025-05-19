terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.83.1"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"
}

module "security_groups" {
  source = "./modules/SecGroups"
  vpc_id = module.vpc.vpc_id
}

module "key" {
  source = "./modules/key"
}

module "frontend" {
  source                = "./modules/FrontEnd"
  vpc_id                = module.vpc.vpc_id
  public_subnets        = module.vpc.public_subnets
  fe_security_group_ids = module.security_groups.fe_sg_id
  alb_Sec_group         = module.security_groups.alb_sg_id
  key_name              = module.key.key_name
  ami_id                = data.aws_ami.ubuntu.id
  backend_alb_dns       = module.backend.be_alb_dns_name
}

module "backend" {
  source                = "./modules/BackEnd"
  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  be_security_group_ids = module.security_groups.be_sg_id
  alb_Sec_group         = module.security_groups.alb_sg_id
  key_name              = module.key.key_name
  ami_id                = data.aws_ami.ubuntu.id
}

module "database" {
  source                = "./modules/DB"
  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  db_security_group_ids = module.security_groups.db_sg_id
  DBPass                = var.DBPass
}

module "CloudFront" {
  source       = "./modules/CloudFront"
  alb_dns_name = module.frontend.fe_alb_dns_name
}
module "AutoScaling" {
  source                     = "./modules/ASG"
  public_subnets             = module.vpc.public_subnets
  private_subnets            = module.vpc.private_subnets
  fe_lt_id                   = module.frontend.fe_lt_id
  be_lt_id                   = module.backend.be_lt_id
  fe_aws_lb_target_group_arn = module.frontend.fe_aws_lb_target_group_arn
  be_aws_lb_target_group_arn = module.backend.be_aws_lb_target_group_arn
}
module "CloudWatch" {
  source                  = "./modules/CloudWatch"
  autoscaling_group_names = [module.AutoScaling.fe_autoscaling_group_names, module.AutoScaling.be_autoscaling_group_names]
  scale_out_arns          = [module.AutoScaling.fe_scale_out_arns, module.AutoScaling.be_scale_out_arns]
  scale_in_arns           = [module.AutoScaling.fe_scale_in_arns, module.AutoScaling.be_scale_in_arns]
}
