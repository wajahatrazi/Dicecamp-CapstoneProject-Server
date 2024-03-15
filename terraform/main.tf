provider "aws" {
  region = "us-west-2"  # Update with your preferred region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Create a security group for the server
resource "aws_security_group" "server_sg" {
  name        = "server_sg"
  description = "Security group for server"

  ingress {
    from_port   = 8000  # Allow incoming connections on port 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add more ingress rules as needed
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create a subnet
resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"  # Update with your preferred AZ
}

# Provision an EC2 instance for the server
resource "aws_instance" "server_instance" {
  ami                    = "ami-0c55b159cbfafe1f0"  # Ubuntu 22.04 LTS AMI, change as needed
  instance_type          = "t2.micro"
  key_name               = "capstoneproject-dice"  # Update with your SSH keypair name
  subnet_id              = aws_subnet.subnet_a.id
  security_groups        = [aws_security_group.server_sg.id]
  
  tags = {
    Name = "ServerInstance"
  }

  # Execute remote commands to set up Docker and run the server container
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo docker run -d -p 8000:8000 server-image:latest"  # Replace server-image:latest with your Docker image name and tag
    ]
  }

  # Copy server.py to the instance
  provisioner "file" {
    source      = "server.py"
    destination = "/home/ubuntu/server.py"  # Update with the path on your instance
  }

  # You can add more provisioners as needed, such as copying Dockerfile.server and requirements.txt
}

# Output server public IP
output "server_public_ip" {
  value = aws_instance.server_instance.public_ip
}
