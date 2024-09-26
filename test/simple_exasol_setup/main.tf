provider "aws" {
  region = "eu-central-1"
  profile = var.aws_profile
}

locals {
  project_tag = replace(var.project, " ", "-")
  tags = merge(var.additional_tags, {
    "exa:owner" : var.owner,
    "exa:deputy" : var.deputy
    "exa:project" : var.project,
  })
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = merge(local.tags, {
    "Name" : "VPC for ${var.project}"
  })
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"

  tags = merge(local.tags, {
    "Name" : "Subnet for ${var.project}"
  })
}


resource "aws_default_route_table" "my_routing_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = merge(local.tags, {
    "Name" : "Route Table for ${var.project}"
  })
}

resource "aws_security_group" "exasol_db_security_group" {
  name = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "SSH from the internet"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ExaOperation access from the internet"
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SQL access from the internet"
    from_port = 8563
    protocol = "tcp"
    to_port = 8563
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    self = true
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    "Name" : "Security Group for Exasol cluster for ${var.project}"
  })
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits = "4096"
}

resource "aws_key_pair" "ssh_key" {
  key_name = "${local.project_tag}-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.tags, {
    "Name" : "Gateway for Exasol cluster for ${var.project}"
  })
}

resource "random_password" "exasol_admin_password" {
  length = 20
  numeric = true
  # with some special chars login does not work
  special = false
  min_upper = 1
  min_lower = 1
  min_numeric = 1
}

module "exasol" {
  source = "../../"
  cluster_name = "${local.project_tag}-exasol-cluster"
  database_name = "exadb"
  ami_image_name = "Exasol-R7.1.26-PAYG"
  sys_user_password = var.exasol_sys_password
  admin_user_password = var.exasol_admin_password
  management_server_instance_type = "m5.large"
  datanode_instance_type = "m5.large"
  datanode_count = "1"
  standbynode_count = "0"
  public_ip = true

  # These values can be obtained from other modules.
  key_pair_name = aws_key_pair.ssh_key.key_name
  subnet_id = aws_subnet.subnet.id
  security_group_id = aws_security_group.exasol_db_security_group.id

  # Variables used in tags.
  project = var.project
  project_name = var.project
  owner = var.owner
  environment = "dev"
  license = "./exasolution.lic"
}

output "datanode_ip" {
  value = module.exasol.first_datanode_ip
}
