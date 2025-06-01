resource "aws_instance" "app" {
  ami                    = data.aws_ami.amzn2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_a.id
  security_groups        = [aws_security_group.instance_sg.id]
  key_name               = "vockey"
  associate_public_ip_address = true

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "${var.project_name}-instance"
  }
}


data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


