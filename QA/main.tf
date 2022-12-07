# Configure aws provider
provider "aws" {
        region = "ap-south-1"
        access_key = "xxxx"
        secret_key = "yyyy"
}

# Create vpc
module "vpc" {
	source = "../Terraform/modules/vpc_module"
	region = var.region
	project_name = var.project_name
	vpc_cidr = var.vpc_cidr
	public_subnet_az1_cidr = var.public_subnet_az1_cidr
	public_subnet_az2_cidr = var.public_subnet_az2_cidr
	private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
	private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
	private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
	private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  environment = var.environment
}
# Create nat gateway

module "nat_gateway" {
	source 				= "../Terraform/modules/Nat-Gateway_module"
	public_subnet_az1_id		= module.vpc.public_subnet_az1_id
	internet_gateway     		= module.vpc.internet_gateway
	public_subnet_az2_id 		= module.vpc.public_subnet_az2_id
	vpc_id 	    	    		= module.vpc.vpc_id
	private_app_subnet_az1_id 	= module.vpc.private_app_subnet_az1_id
	private_data_subnet_az1_id 	= module.vpc.private_data_subnet_az1_id
	private_app_subnet_az2_id 	= module.vpc.private_app_subnet_az2_id
	private_data_subnet_az2_id 	= module.vpc.private_data_subnet_az2_id
  environment = var.environment
}

module "security_group" {
	source = "../Terraform/modules/SecurityGroups_module"
	vpc_id = module.vpc.vpc_id
  environment = var.environment
}

module "EC2" {
  source = "../Terraform/modules/EC2_module"
  ami    = var.ami
  instance_size = var.instance_size
  //vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_az1_id
  security_group_id = module.security_group.alb_security_group_id
  environment = var.environment
}
module "RDS" {
  source                = "../Terraform/modules/RDS_module"
  engine_name           = var.engine_name
  engine_version        = var.engine_version
  instance_type         = var.instance_type
  private_app_subnet_az1_id     = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id     = module.vpc.private_app_subnet_az2_id
  availability_zone     = var.availability_zone
  user_name             = var.user_name
  passwd                = var.passwd
  project_name          = var.project_name
  environment = var.environment
}
module "application_load_balancer" {
  source                  = "../Terraform/modules/Loadbalancer_module"
  project_name            =  module.vpc.project_name
  alb_security_group_id   =  module.security_group.alb_security_group_id
  public_subnet_az1_id    =  module.vpc.public_subnet_az1_id
  public_subnet_az2_id    =  module.vpc.public_subnet_az2_id
  vpc_id                  =  module.vpc.vpc_id
  environment = var.environment
}
