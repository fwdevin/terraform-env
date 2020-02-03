# Add AWS as a provider and configure the default region
provider "aws" {
  region = "us-east-1"
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