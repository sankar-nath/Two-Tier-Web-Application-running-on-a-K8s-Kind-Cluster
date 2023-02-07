provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "sankar_server" {
  ami                  = data.aws_ami.latest_amazon_linux.id
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.public_subnet.id
  iam_instance_profile = "LabInstanceProfile"
  security_groups      = [aws_security_group.webapp_sg.id]
  key_name             = aws_key_pair.my_key.key_name

  tags = {
    Name = "webapp-server"
  }
}

# Adding SSH key to Amazon EC2
resource "aws_key_pair" "my_key" {
  key_name   = "sankarKey"
  public_key = file("sankarKey.pub")
}

resource "aws_ecr_repository" "webapp_images" {
  name = "webapp-images"
}

resource "aws_ecr_repository" "mysql_images" {
  name = "mysql-images"
}