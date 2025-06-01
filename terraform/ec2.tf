resource "aws_instance" "app" {
  ami                         = "ami-0c94855ba95c71c99"
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.subnet_a.id
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/user_data.sh")

  root_block_device {
    volume_size = 8
  }

  tags = {
    Name = "${var.project_name}-ec2"
  }
}


