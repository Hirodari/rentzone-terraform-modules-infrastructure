locals {
  region      = var.region
  project     = var.project_name
  environment = var.environment
}

# create vpc module
module "vpc" {
  source                       = "git@github.com:Hirodari/rentzone-terraform-modules-ecs.git//vpc"
  project_name                 = local.project
  environment                  = local.environment
  region                       = local.region
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

# create natgateway module
module "natgateway" {
  source                     = "git@github.com:Hirodari/rentzone-terraform-modules-ecs.git//natgateway"
  project_name               = local.project
  environment                = local.environment
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  internet_gateway           = module.vpc.internet_gateway
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  vpc_id                     = module.vpc.vpc_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
}

# create security groups module
module "security-groups" {
  source       = "git@github.com:Hirodari/rentzone-terraform-modules-ecs.git//security-groups"
  project_name = local.project
  environment  = local.environment
  vpc_id       = module.vpc.vpc_id
  ssh_ip       = var.ssh_ip
}

# create rds module
module "rds" {
  source                     = "git@github.com:Hirodari/rentzone-terraform-modules-ecs.git//rds"
  project_name               = local.project
  environment                = local.environment
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  db_snapshot_identifier     = var.db_snapshot_identifier
  db_instance_class          = var.db_instance_class
  availability_zone_2        = module.vpc.availability_zone_2
  db_instance_identifier     = var.db_instance_identifier
  multi_az_deployment        = var.multi_az_deployment
  database_security_group_id = module.security-groups.database_security_group_id
}

# create s3 bucket/file to upload module
module "s3" {
  source          = "git@github.com:Hirodari/rentzone-terraform-modules-ecs.git//s3"
  project_name    = local.project
  env_bucket_name = var.env_bucket_name
  env_filename    = var.env_filename
}

# create acm module to create certificate for inflight encryption
module "acm" {
  source                    = "git@github.com:Hirodari/rentzone-terraform-modules-ecs.git//acm"
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
}

# create alb module
module "alb" {
  source                = "git@github.com:Hirodari/rentzone-terraform-modules-ecs.git//alb"
  project_name          = local.project
  environment           = local.environment
  alb_security_group_id = module.security-groups.alb_security_group_id
  public_subnet_az1_id  = module.vpc.public_subnet_az1_id
  public_subnet_az2_id  = module.vpc.public_subnet_az2_id
  vpc_id                = module.vpc.vpc_id
  certificate_arn       = module.acm.certificate_arn
}