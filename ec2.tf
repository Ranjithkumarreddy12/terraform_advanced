resource "aws_instance" "ec2" {
    count = "${var.env == "Dev" ? 3 : 1}"
    ami = var.aws_ami
    instance_type = "t2.micro"
    key_name = "Ranjith"
    subnet_id = "${element(aws_subnet.public_subnets.*.id, count.index)}"
    vpc_security_group_ids = ["${aws_security_group.allow_sg.id}"]
    associate_public_ip_address = true	
    tags = {
        Name = "${element(var.instance_name, count.index)}"
    }
    user_data = <<-EOF
		#!/bin/bash
        sudo apt-get update
		sudo apt-get install -y nginx
        sudo service nginx start
		echo "<h1>Deployed via Terraform-Public-Server-${count.index+1}</h1>" | sudo tee /var/www/html/index.nginx-debian.html
	EOF
}