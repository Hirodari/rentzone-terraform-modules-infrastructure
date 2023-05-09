# environment variables
variable "region" {}
variable "project_name" {}
variable "environment" {}

# vpc variables
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_app_subnet_az1_cidr" {}
variable "private_app_subnet_az2_cidr" {}
variable "private_data_subnet_az1_cidr" {}
variable "private_data_subnet_az2_cidr" {}

# security groups variables
variable "ssh_ip" {}

# rds variables
variable "db_snapshot_identifier" {}
variable "db_instance_class" {}
variable "db_instance_identifier" {}
variable "multi_az_deployment" {}

# s3 variables
variable "env_bucket_name" {}
variable "env_filename" {}

# acm variables
variable "domain_name" {}
variable "subject_alternative_names" {}

# ecs variables 
variable "cpu_architecture" {}
variable "container_image" {}