provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "class_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = "Classtest"
  }
}

resource "aws_subnet" "class_public_subnet" {
  vpc_id                  = aws_vpc.class_vpc.id
  cidr_block              = "10.10.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1b"

  tags = {
    Name = "Class_public_subnet"
  }
}

resource "aws_internet_gateway" "class_gateway" {
  vpc_id = aws_vpc.class_vpc.id

  tags = {
    Name = "Class_gateway"
  }
}

resource "aws_route_table" "class_rtb" {
  vpc_id = aws_vpc.class_vpc.id

  tags = {
    Name = "Class_pb_rtb"
  }
}

resource "aws_route" "class_route" {
  route_table_id         = aws_route_table.class_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.class_gateway.id
}

resource "aws_route_table_association" "class_public_ass" {
  subnet_id      = aws_subnet.class_public_subnet.id
  route_table_id = aws_route_table.class_rtb.id
}

resource "aws_security_group" "class_sg" {
  name        = "class_sg"
  description = "Class security group"
  vpc_id      = aws_vpc.class_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

data "aws_ami" "class_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

}
resource "aws_key_pair" "class_auth" {
  key_name   = "classkey"
  public_key = file("~/.ssh/class.pub")
}

resource "aws_instance" "class" {
  for_each               = var.servidores
  ami                    = data.aws_ami.class_ami.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.class_auth.id
  vpc_security_group_ids = [aws_security_group.class_sg.id]
  subnet_id              = aws_subnet.class_public_subnet.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = each.value.name
  }
}