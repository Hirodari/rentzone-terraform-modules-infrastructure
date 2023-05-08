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