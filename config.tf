# Add AWS as a provider and configure the default region
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "test-vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create Sub1
resource "aws_subnet" "my_subnet" {
  vpc_id            = "${aws_vpc.test-vpc.id}"
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Sub1"
  }
}

# Create Sub2
resource "aws_subnet" "my_subnet" {
  vpc_id            = "${aws_vpc.test-vpc.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Sub2"
  }
}

# Create Sub3
resource "aws_subnet" "my_subnet" {
  vpc_id            = "${aws_vpc.test-vpc.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "Sub3"
  }
}

# Create Sub4
resource "aws_subnet" "my_subnet" {
  vpc_id            = "${aws_vpc.test-vpc.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1d"

  tags = {
    Name = "Sub4"
  }
}

# Get the latest RHEL 8 image ID
data "aws_ami" "redhat" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-8.0.0_HVM"]
  }

  owners = ["309956199498"] # Red Hat
}

# Create a t2.micro EC2 instance type 
# (Standard_DS1_v2 seems to be an Azure type)
resource "aws_instance" "test-instance" {
  ami           = "${data.aws_ami.redhat.id}"
  instance_type = "t2.micro"
}

# Add EBS volume
resource "aws_ebs_volume" "test-volume" {
  availability_zone = "us-east-1a"
  size              = 20
}

# Attach EBS volume to EC2 instance
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sda1"
  volume_id   = "${aws_ebs_volume.test-volume.id}"
  instance_id = "${aws_instance.test-instance.id}"
}