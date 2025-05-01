provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_zone}-vpc"
  }
}

module "myapp-subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  env_zone = var.env_zone
  avail_zone = var.avail_zone
  vpc_id = aws_vpc.myapp-vpc.id
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}


# resource "aws_route_table_association" "myapp-default-rtb-association" {
#   subnet_id = aws_subnet.myapp-subnet-1.id
#   route_table_id = aws_default_route_table.myapp-default-rtb_id
# }


module "myapp-webservers" {
  source = "./modules/webservers"
  vpc_id = aws_vpc.myapp-vpc.id
  my_ip = var.my_ip
  env_zone = var.env_zone
  public_key_path = var.public_key_path
  instance_type = var.instance_type
  subnet_id = module.myapp-subnet.subnet_id
  avail_zone = var.avail_zone
  image_name = var.image_name
}



# Uncomment the following block if you want to create a custom security group instead of using the default one


# resource "aws_security_group" "myapp-sg" {
#   vpc_id = aws_vpc.myapp-vpc.id
#   name = "myapp-sg"
#   ingress {
#     from_port = 22
#     to_port = 22
#     protocol = "tcp"
#     cidr_blocks = [var.my_ip]
#     }

#   ingress {
#     from_port = 8080
#     to_port = 8080
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     }

#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     prefix_list_ids = []
#     }

#   tags = {
#     Name: "${var.env_zone}-sg"
#   }
# }


# Uncomment the following block if you want to create a custom route table instead of using the default one



# resource "aws_route_table" "myapp-route-table" {
#   vpc_id = aws_vpc.myapp-vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.myapp-igw.id
#   }
#   tags = {
#     Name: "${var.env_zone}-route-table"
#   }
# }



# resource "aws_route_table_association" "myapp-rtb-association" {
#   subnet_id = aws_subnet.myapp-subnet-1.id
#   route_table_id = aws_route_table.myapp-route-table.id
# }