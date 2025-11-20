########################################
# Security Groups
########################################

# Frontend Security Group
resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  vpc_id      = aws_vpc.main_vpc.id
  description = "Allow HTTP/HTTPS traffic from the internet"

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# RESULT app (port 81)
  ingress {
    from_port   = 81
    to_port     = 81
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "frontend-sg"
  }
}

# Backend Security Group
resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  vpc_id      = aws_vpc.main_vpc.id
  description = "Allows inbound traffic from Vote/Result EC2 to Redis port (6379), and allows outbound to Postgres."

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  # Allow SSH from frontend (bastion host)
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = [aws_vpc.main_vpc.cidr_block]
    #security_groups = [aws_security_group.db_sg.id]
  }

  tags = {
    Name = "backend-sg"
  }
}

#  Database Security Group 
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow Postgres only from Worker"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description     = "Postgres from Worker/Redis tier"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  # Allow Postgres from backend_sg  
  ingress {
    description     = "Postgres from backend"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  # Allow SSH from frontend (bastion host)
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}
