# VPC Module

module "aws_vpc" {
  source = "./modules/vpc"

vpc-cidr                                 = var.vpc-cidr
subnet-cidrblock-pub1                    = var.subnet-cidrblock-pub1
subnet-cidrblock-pub2                    = var.subnet-cidrblock-pub2
subnet-cidrblock-pri1                    = var.subnet-cidrblock-pri1
subnet-cidrblock-pri2                    = var.subnet-cidrblock-pri2
subnet-az-2a                             = var.subnet-az-2a    
subnet-az-2b                             = var.subnet-az-2b    
routetable-cidr                          = var.routetable-cidr     
subnet-map_public_ip_on_launch_public    = var.subnet-map_public_ip_on_launch_public
subnet-map_public_ip_on_launch_private   = var.subnet-map_public_ip_on_launch_private

}

# ALB Module

module "alb" {
  source = "./modules/alb"


application-port                         = var.application-port

  # Use these outputs
  vpc_id            = module.aws_vpc.vpc-id
  subnetpub1_id     = module.aws_vpc.subnet-pub1
  subnetpub2_id     = module.aws_vpc.subnet-pub2
  certificate_arn   = module.route53.certificate_arn
}

# ECS Module

module "ecs" {
  source = "./modules/ecs"

ecs-container-name                       = var.ecs-container-name  
ecs-image                                = var.ecs-image 
ecs-dockerport                           = var.ecs-dockerport  
ecs-memory                               = var.ecs-memory
ecs-cpu                                  = var.ecs-cpu
ecs-desiredcount                         = var.ecs-desiredcount
application-port                         = var.application-port


  # Use these outputs
  tg_arn            = module.alb.tg_arn
  subnetpri1_id     = module.aws_vpc.subnet-pri1
  vpc_id            = module.aws_vpc.vpc-id
}

# Route53 Module

module "route53" {
  source = "./modules/route53"

domain_name                              = var.domain_name

  # Use these outputs
  alb_dns           = module.alb.alb_dns
  alb_zoneid        = module.alb.alb_zoneid
}
