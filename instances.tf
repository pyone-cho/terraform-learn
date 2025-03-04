# 1 - Data Block
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# 2 - Instance Block
resource "aws_instance" "web" {
    count = var.create_instance ? 1 : 0     // count = var.function ? desire_ec2 : 0

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.server_config.type

  tags = {
    Name = var.server_config.name
  }
}
