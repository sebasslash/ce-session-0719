module "ce-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ce-session-vpc-${random_integer.suffix.id}"
  cidr = "10.0.0.0/16"

  azs = var.vpc_azs 
  private_subnets = var.vpc_private_subnets
  public_subnets = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

resource "aws_security_group" "allow_ssh_pub" {
  name = "ce-sg-allow_ssh-${random_integer.suffix.id}"
  description = "Allow SSH inbound traffic"
  vpc_id = module.ce-vpc.vpc_id

  ingress {
    description = "SSH from internet"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0 
    to_port = 0 
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ce-sg-allow_ssh_pub"
  }
}

resource "aws_security_group" "allow_http_pub" {
  name = "ce-sg-allow_http-${random_integer.suffix.id}"
  description = "Allow HTTP inbound traffic"
  vpc_id = module.ce-vpc.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port = 80
    to_port = 80 
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh_priv" {
  name = "ce-sg-allow_ssh_priv-${random_integer.suffix.id}"
  description = "Allow SSH inbound traffic"
  vpc_id = module.ce-vpc.vpc_id

  ingress {
    description = "From internal VPC clients"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port = 0 
    to_port = 0 
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ce-sg-allow_ssh_priv"
  }
}

resource "aws_security_group" "allow_sql_priv" {
  name = "ce-sg-allow_sql_priv-${random_integer.suffix.id}"
  description = "Allow connection to Postgres instance"
  vpc_id = module.ce-vpc.vpc_id

  ingress {
    description = "From internal VPC clients"
    from_port = 5432 
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port = 0 
    to_port = 0 
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
}
