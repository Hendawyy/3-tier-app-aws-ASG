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
  source             = "./modules/FrontEnd"
  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.vpc.public_subnets
  security_group_ids = module.security_groups.fe_sg_id
  key_name           = module.key.key_name
}

module "backend" {
  source             = "./modules/BackEnd"
  vpc_id             = module.vpc.vpc_id
  private_subnets    = module.vpc.private_subnets
  security_group_ids = module.security_groups.be_sg_id
  key_name           = module.key.key_name
}

module "database" {
  source             = "./modules/DB"
  vpc_id             = module.vpc.vpc_id
  private_subnets    = module.vpc.private_subnets
  security_group_ids = module.security_groups.db_sg_id
}
