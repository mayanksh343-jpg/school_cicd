############################
# Ubuntu AMI
#this data block will give latest ami id 

data "aws_ami" "ubuntu" {
#if give many option it pick latest one 
  most_recent = true
#check if came from real publisher or not
  owners = ["099720109477"]

  filter {
    #name = "Which field should AWS search?"
    name = "name"

    values = [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
    ]
  }

}

############################
# Security Group
############################

resource "aws_security_group" "ansible_sg" {

  name = "ansible-sg"

  ingress {

    from_port = 22
    to_port = 22
    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

 ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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


  egress {

    from_port = 0
    to_port = 0
    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "ansible-sg"
  }

}

############################
# EC2 Instances
############################

resource "aws_instance" "server" {

  count = var.instance_count

  ami = data.aws_ami.ubuntu.id

  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = [
    aws_security_group.ansible_sg.id
  ]

   root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {

    Name = "Server-${count.index + 1}"

  }

}

############################
# Generate inventory.ini
############################

resource "local_file" "inventory" {

  filename = "inventory.ini"
//%for if for loop ha jo multiple instances ka liay ha
  content = <<EOF

[servers]

%{ for index, instance in aws_instance.server ~}
server${index + 1} ansible_host=${instance.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${var.private_key_path}
%{ endfor ~}
EOF

}