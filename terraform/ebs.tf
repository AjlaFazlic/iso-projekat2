resource "aws_ebs_volume" "db_volume" {
  availability_zone = var.availability_zone
  size = 10

  tags = {
    Name = "${var.project_name}-db-volume"
  }
}

resource "aws_volume_attachment" "db_attachment" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.db_volume.id
  instance_id = aws_instance.app.id
  force_detach = true
}
