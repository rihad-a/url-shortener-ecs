# General Variables 

variable "domain_name" {
  type        = string
  description = "The domain name for the infrastructure"
}

# Module Variables 

variable "alb_dns" {
  type        = string
  description = "The alb dns from the alb module"
}

variable "alb_zoneid" {
  type        = string
  description = "The alb zone id from the alb module"
}
