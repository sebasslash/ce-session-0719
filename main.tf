terraform {
  # backend "s3" {
  #   bucket = "ce-session-tfstate-bucket-{RANDOM_NUMBER_HERE}"
  #   key = "state/terraform.tfstate"
  #   region = "us-east-1"
  #   encrypt = true
  #
  #   profile = {YOUR AWS PROFILE}
  #   OR
  #   access_key = {YOUR AWS ACCESS KEY}
  #   secret_key = {YOUR AWS SECRET KEY}
  #   token = {YOUR AWS SESSION TOKEN}
  #
  #   kms_key_id = "alias/tf-bucket-key-{RANDOM_NUMBER_HERE}"
  #   dynamodb_table = "terraform-state-{RANDOM_NUMBER_HERE}"
  # }
}

resource "aws_instance" "webapp" {
  ami = var.ec2_ami
  instance_type = "t2.micro"
  tags = {
    Name = "Webapp-${random_integer.suffix.id}"
  }
}

resource "aws_instance" "postgres"  {
  ami = var.ec2_ami
  instance_type = "t2.micro"
  tags = {
    Name = "Postgres-${random_integer.suffix.id}"
  }
}
