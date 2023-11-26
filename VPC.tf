provider "aws" {
  region  = var.region
}

//create instance
resource "aws_instance" "demo" {
 ami = var.ami
 key_name = var.key
 instance_type = var.instance-type
 associate_public_ip_address = true
 subnet_id = aws_subnet.demo-subnet.id
 vpc_security_group_ids = [aws_security_group.demo-vpc-sg.id]
} 

// Create VPC
resource "aws_vpc" "demo-vpc" {
  cidr_block = var.vpc-cidr
}

// Create Subnet
resource "aws_subnet" "demo-subnet" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = var.subnet1-cidr
  availability_zone = var.subnet-az
  map_public_ip_on_launch = true
  tags = {
    Name = "demo-subnet"
  }
}

resource "aws_subnet" "demo-subnet-2" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = var.subnet2-cidr
  availability_zone = var.subnet-az-2
  map_public_ip_on_launch = true

  tags = {
    Name = "demo-subnet-2"
  }
}
 
// Create  Internet Gateway
resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "demo-igw"
  }
}

//create route table
resource "aws_route_table" "demo-rt" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = var.route-cidr
    gateway_id = aws_internet_gateway.demo-igw.id
  }


  tags = {
    Name = "demo-rt"
  }
}

// Associate subnet with route table
resource "aws_route_table_association" "demo-association" {
  subnet_id      = aws_subnet.demo-subnet.id
  route_table_id = aws_route_table.demo-rt.id
}

resource "aws_route_table_association" "demo-association-2" {
  subnet_id      = aws_subnet.demo-subnet-2.id
  route_table_id = aws_route_table.demo-rt.id
}

// Security Group
resource "aws_security_group" "demo-vpc-sg" {
  name        = "demo-vpc-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "demo-vpc-sg"
  }
}

module "sgs" {
  source = "./sg-eks"
  vpc_id = aws_vpc.demo-vpc.id
}

module "eks" {
  source = "./eks"
  sg_ids = module.sgs.security_group_public
  subnet_ids = [aws_subnet.demo-subnet.id,aws_subnet.demo-subnet-2.id]
  vpc_id = aws_vpc.demo-vpc.id
}

