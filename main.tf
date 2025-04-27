provider "aws" {
  region = "us-east-1"
}

variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable env_zone {}
variable avail_zone{}
variable my_ip {}

# variable cidr_blocks {
#   description = "cidr blocks for vpc and subnets"
#   type = list(object({
#     cidr_block = string
#     name = string
#   })) 
# }

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_zone}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name: "${var.env_zone}-subnet-1"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name: "${var.env_zone}-igw"
  }
}

# Default route table
# This block creates a default route table for the VPC and adds a route to the internet gateway
resource "aws_default_route_table" "myapp-default-rtb" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name: "${var.env_zone}-default-rtb"
  }
}

resource "aws_route_table_association" "myapp-default-rtb-association" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_default_route_table.myapp-default-rtb.id
}


resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_vpc.myapp-vpc.id

  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
    }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
    }

  tags = {
    Name: "${var.env_zone}-sg"
  }
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