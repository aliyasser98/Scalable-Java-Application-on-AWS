packer {
    required_plugins {
        docker = {
        version = ">= 1.1.1"
        source  = "github.com/hashicorp/docker"
        }
        ansible = {
        version = ">= 1.0.4"
        source  = "github.com/hashicorp/ansible"
        }
        amazon = {
        version = ">= 1.1.1"
        source  = "github.com/hashicorp/amazon"
        }
    }
}
variable "app_version" {
    type    = string
    default = "1.0.0"
}
locals {
    app_name = "java-app-${var.app_version}"
}
source "amazon-ebs" "java-app" {
    ami_name      = "java-app-${var.app_version}"
    instance_type = "t2.micro"
    region        = "us-east-1"
    source_ami    = "ami-020cba7c55df1f615"
    ssh_username  = "ubuntu"
    tags = {
        Name = local.app_name
    }
}
build {
    sources = [
        "source.amazon-ebs.java-app"
    ]
    provisioner "ansible" {
        playbook_file = "ansible/java-app.yaml"
    }
}
