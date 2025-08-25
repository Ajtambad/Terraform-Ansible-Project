terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }
    backend "s3" {
        bucket = "terraform-s3-state-amogh"
        key = "/home/ec2-user/Terraform"
        region = "us-east-1"
    }

    required_version = ">= 1.2.0"
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_launch_template" "web-server-template" {
    name = "create-web-host"
    image_id = "ami-00a929b66ed6e0de6"
    security_group_names = ["launch-wizard-1"]
    instance_type = "t2.micro"
    key_name = "AWS-key-pair"
}

resource "aws_autoscaling_group" "web-host-instance" {
    availability_zones = ["us-east-1a"]
    desired_capacity = 1
    min_size = 1
    max_size = 1

    tag {
        key = "Name"
        value = "web-host-instance"
        propagate_at_launch = true
      }

    launch_template {
        id = "${aws_launch_template.web-server-template.id}"
        version = "$Latest"
    }
}