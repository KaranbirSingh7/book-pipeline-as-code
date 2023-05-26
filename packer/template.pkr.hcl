packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS REGION"
}

variable "profile" {
  type        = string
  default     = "default"
  description = "AWS PROFILE"
}

variable "source_ami" {
  type        = string
  default     = "ami-0889a44b331db0194"
  description = "Linux AMI to use for baking"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
}

data "amazon-ami" "image" {
  filters = {
    name                = "amzn2-ami-ecs-hvm-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["amazon"]
  profile     = var.profile
  region      = var.region
}

source "amazon-ebs" "jenkins_master" {
  ami_description = "Amazon Linux Image with Jenkins server"
  ami_name        = "jenkins-master-2.204.1"
  instance_type   = var.instance_type
  profile         = var.profile
  region          = var.region
  run_tags = {
    Name = "packer-builder"
  }
  source_ami            = data.amazon-ami.image.id
  ssh_username          = "ec2-user"
  force_deregister      = true
  force_delete_snapshot = true
}

build {
  sources = [
    "source.amazon-ebs.jenkins_master"
  ]
  provisioner "file" {
    source      = "./scripts"
    destination = "/tmp"
  }
  provisioner "shell" {
    execute_command = "sudo -E -S sh '{{ .Path }}'"
    script          = "./setup.sh"
  }
}
