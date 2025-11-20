resource "aws_instance" "instance-a-frontend" {
  ami                         = var.ami
  instance_type               = "t3.micro"
  key_name                    = var.key_pair_name
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.frontend_sg.id]

  tags = { Name = "instance-a-frontend" }
}

resource "aws_instance" "instance-b-backend" {
  ami                    = var.ami
  instance_type          = "t3.micro"
  key_name               = var.key_pair_name
  subnet_id              = aws_subnet.private_subnet_a.id
  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  tags = { Name = "instance-b-backend" }
}

resource "aws_instance" "instance-c-db" {
  ami                    = var.ami
  instance_type          = "t3.micro"
  key_name               = var.key_pair_name
  subnet_id              = aws_subnet.private_subnet_b.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = { Name = "instance-c-db" }
}