# Internet VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags {
    Name = "main"
  }
}

# Subnets
resource "aws_subnet" "main_public" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.AWS_AVAILABILITY_ZONE}"

  tags {
    Name = "main-public"
  }
}

# Internet GW
resource "aws_internet_gateway" "main_gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "main"
  }
}

# Route tables
resource "aws_route_table" "main_public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main_gw.id}"
  }

  tags {
    Name = "main-public"
  }
}

# Route associations public
resource "aws_route_table_association" "main_public" {
  subnet_id      = "${aws_subnet.main_public.id}"
  route_table_id = "${aws_route_table.main_public.id}"
}
