# General Variables

variable "domain_name" {
  type        = string
  description = "The domain name for the infrastructure"
}

variable "application-port" {
  type        = number
  description = "The port for the application"
}

variable "aws_tags" {
  description = "Tags for Resources"
  type        = map(string)
}

# AWS VPC Variables

variable "vpc-cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "subnet-cidrblock-pub1" {
  type        = string
  description = "The CIDR block for public subnet 1"
}

variable "subnet-cidrblock-pub2" {
  type        = string
  description = "The CIDR block for public subnet 2"
}

variable "subnet-cidrblock-pri1" {
  type        = string
  description = "The CIDR block for private subnet 1"
}

variable "subnet-cidrblock-pri2" {
  type        = string
  description = "The CIDR block for private subnet 2"
}

variable "subnet-az-2a" {
  type        = string
  description = "Availability zone for the 'a' subnets"
}

variable "subnet-az-2b" {
  type        = string
  description = "Availability zone for the 'b' subnets"
}

variable "routetable-cidr" {
  type        = string
  description = "Destination CIDR for the route table"
}

variable "subnet-map_public_ip_on_launch_public" {
  type        = bool
  description = "Boolean to map public IP on launch for public subnets"
}

variable "subnet-map_public_ip_on_launch_private" {
  type        = bool
  description = "Boolean to map public IP on launch for private subnets"
}

# ECS Variables

variable "ecs-container-name" {
  type        = string
  description = "The name of the container in the task definition"
}

variable "ecs-image" {
  type        = string
  description = "The url for the latest docker image"
}

variable "ecs-dockerport" {
  type        = number
  description = "The port the docker image uses"
}

variable "ecs-memory" {
  type        = number
  description = "The memory value for the task definition"
}

variable "ecs-cpu" {
  type        = number
  description = "The cpu value for the task definition"
}

variable "ecs-desiredcount" {
  type        = number
  description = "The number of instances for the task definition to be deployed"
}

