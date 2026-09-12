# vpc
resource "aws_vpc" "main"{
    cidr_block = "10.20.0.0/16"
}

# subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.20.1.0/24"
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.20.11.0/24"
}

# igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# route_table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# route_table_association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# sg
resource "aws_security_group" "ec2" {
  name        = "ec2"
  description = "Allow HTTP/HTTPS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4         = var.ssh_allowed_cidr
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# eip
resource "aws_eip" "ec2" {
  domain = "vpc"
}

resource "aws_eip_association" "ec2" {
  instance_id   = aws_instance.app.id
  allocation_id = aws_eip.ec2.id
}

# EC2
resource "aws_instance" "app" {
  ami = "ami-08d0fa6d084fda9db"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_subnet.id
  
  key_name = var.ssh_key
  
  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]
}
