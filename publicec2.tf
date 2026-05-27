resource "aws_key_pair" "mykey"{
    key_name = "mykey"
    public_key = file(var.pub_key_name)
}
resource "aws_security_group" "public_sg" {
  name   = "public-sg"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public_ec2" {
  ami           = "ami-0ec10929233384c7f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id

  key_name = var.pri_key_name

  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    Name = "Public-EC2"
  }
}
