
resource "aws_route_table" "public_routing_table" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
    tags = {
        Name = "${var.Main_table}"
    }
}

resource "aws_route_table" "private_routing_table" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags = {
        Name = "${var.private_table}"
    }
}


resource "aws_route_table_association" "terraform-public" {
    count = "${length(var.public_cidrs)}"
    subnet_id = "${element(aws_subnet.public_subnets.*.id, count.index)}"
    route_table_id = "${aws_route_table.public_routing_table.id}"
}

resource "aws_route_table_association" "terraform-private" {
    count = "${length(var.private_cidrs)}"
    subnet_id = "${element(aws_subnet.private_subnets.*.id, count.index)}"
    route_table_id = "${aws_route_table.private_routing_table.id}"
}
