terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }

    required_version = ">= 1.2.0"
}

provider "aws" {
    region = "us-east-1"
}

locals {
    user_data_script = <<-EOF
            #!/bin/bash
            echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCjmKRAzPnH2oY1qrQdP1XRf+ywqk9jeDDGn13sGgSO+P5gyeIMmbpGMCvdsNDRzEp4uY+Yw7K3CVNnNpd3wJnFLUfE03KSmy8kNwEiB0Q1fqu1NWqMeTpcG8wbDCmEYq68qCTWFuESsDZB7+iKHZ52pm7HUEldhHyjhb14otkGBrbgHUwJftC2LiUhA9akvOTnT7R43CmZAgPVFaOMe9eLMeqUNQqQtFr1V1TLwwXMH99EVBvZwt/NQZmRpu6JBbysq2b5UQfiuB1TsBlJCmRFKNFp6SKCeBjmYrwqPhzyYx+l1m8EtQYDEL47OxYCN0MmhST+KvzEuga3Bva7cvuEIKMGp89f2TvHhRq9hQt+jJh7b/V02I/+nREsI/+W5M6VJkaPbQbbz2phx+MdcZw0lGhmsgyEsfUqVRb4MVT10qqWazbAsku6Fv24PMl5pShLkHztyQL5/fBya0xBbsRqJKkgKkOy0Z9P4YzTye4DzK2vC1eNwI0EBQ0t+Czahhk= ec2-user@ip-172-31-81-214.ec2.internal" >> /home/ec2-user/.ssh/authorized_keys
            EOF
}

resource "aws_launch_template" "web-server-template" {
    name = "create-web-host"
    image_id = "ami-00a929b66ed6e0de6"
    security_group_names = ["launch-wizard-1"]
    instance_type = "t2.micro"
    key_name = "AWS-key-pair"
    user_data = base64encode(local.user_data_script)
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

/*resource "aws_instance" "host-test" {
  ami = "ami-00a929b66ed6e0de6"
  instance_type = "t2.micro"

    tags = {
        Name = "WebsiteHostInstance"
    }
}*/
