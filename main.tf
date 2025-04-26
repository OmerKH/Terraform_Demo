provider "aws" {
  region = "us-east-1"
}

variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable env_zone {}
variable avail_zone{}

# variable cidr_blocks {
#   description = "cidr blocks for vpc and subnets"
#   type = list(object({
#     cidr_block = string
#     name = string
#   })) 
# }

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name: "${var.env_zone}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.cidr_blocks[1].cidr_block
  availability_zone = "us-east-1a"
  tags = {
    Name: "${var.env_zone}-subnet-1"
  }
}