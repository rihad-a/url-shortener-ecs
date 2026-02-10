# Creating the VPC

resource "aws_vpc" "terraform_vpc" {
    cidr_block = var.vpc-cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true  
    enable_dns_support = true
}

# Creating the internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform_vpc.id
}

# Creating the public and private subnets

resource "aws_subnet" "public_1" {
  cidr_block              = var.subnet-cidrblock-pub1
  vpc_id                  = aws_vpc.terraform_vpc.id
  map_public_ip_on_launch = var.subnet-map_public_ip_on_launch_public
  availability_zone       = var.subnet-az-2a
}
resource "aws_subnet" "private_1" {
  cidr_block              = var.subnet-cidrblock-pri1
  vpc_id                  = aws_vpc.terraform_vpc.id
  map_public_ip_on_launch = var.subnet-map_public_ip_on_launch_private
  availability_zone       = var.subnet-az-2a
}

resource "aws_subnet" "public_2" {
  cidr_block              = var.subnet-cidrblock-pub2
  vpc_id                  = aws_vpc.terraform_vpc.id
  map_public_ip_on_launch = var.subnet-map_public_ip_on_launch_public
  availability_zone       = var.subnet-az-2b
}
resource "aws_subnet" "private_2" {
  cidr_block              = var.subnet-cidrblock-pri2
  vpc_id                  = aws_vpc.terraform_vpc.id
  map_public_ip_on_launch = var.subnet-map_public_ip_on_launch_private
  availability_zone       = var.subnet-az-2b
}

# Creating the nat gateway

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id     = aws_subnet.public_1.id

depends_on = [aws_internet_gateway.gw]

}

# Creating the elastic ip for the nat gateway

resource "aws_eip" "ngw_eip" {

}

# Creating the public route table and relevant associations to public subnets

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = var.routetable-cidr
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_route.id
}

# Creating the private route table and relevant associations to private subnets

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = var.routetable-cidr
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_route.id
}

# Creating endpoint for DynamoDB

resource "aws_vpc_endpoint" "dynamodb" {
    vpc_id              = aws_vpc.terraform_vpc.id
    service_name        = "com.amazonaws.eu-west-2.dynamodb"
    vpc_endpoint_type   = "Gateway"
    route_table_ids     = [aws_route_table.private_route.id]
    policy              = jsonencode({
        "Version"       : "2012-10-17",
        "Statement"     : [
            {
                "Effect"    : "Allow",
                "Principal" : "*",
                "Action"    : "*",
                "Resource"  : "*"
            }
        ]
    })
}
