data "aws_ami" "exasol" {
  most_recent = true
  owners      = [var.ami_image_owner]

  filter {
    name   = "name"
    values = ["*${var.ami_image_name}*"]
  }
}

resource "aws_cloudformation_stack" "exasol_cluster" {
  name         = var.cluster_name
  capabilities = ["CAPABILITY_IAM"]
  on_failure   = "DELETE"
  template_url = "https://exasol-cf-templates.s3.eu-central-1.amazonaws.com/cloudformation_template_v2.0.0.yml"
  parameters = {
    DBSystemName              = var.database_name
    DBPassword                = var.sys_user_password
    ExasolPassword            = var.admin_user_password
    SubnetId                  = var.subnet_id
    DBSecurityGroup           = var.security_group_id
    LicenseServerInstanceType = var.management_server_instance_type
    DatabaseNodeInstanceType  = var.datanode_instance_type
    DBNodeCount               = var.datanode_count
    StandbyNode               = var.standbynode_count
    KeyName                   = var.key_pair_name
    ImageId                   = var.ami_image_id == null ? data.aws_ami.exasol.id : var.ami_image_id
    PublicIP                  = var.public_ip
    CreateS3Bucket            = var.create_s3_bucket
    CreateS3Endpoint          = var.create_s3_endpoint
    CreateKMSEndpoint         = var.create_kms_endpoint
    CreateEC2Endpoint         = var.create_ec2_endpoint
    OpenPorts                 = var.open_ports
    OwnerTag                  = var.owner
    ProjectTag                = var.project
  }

  tags = {
    Name               = "exasol-${var.cluster_name}-${var.environment}"
    Project            = var.project
    "exa:project"      = var.project
    "exa:project.name" = var.project_name
    Owner              = var.owner
    "exa:owner"        = var.owner
    Environment        = var.environment
    WaitedOn           = var.waited_on == null ? "waited_on_null" : var.waited_on
  }
}

data "aws_instance" "exasol_first_datanode" {
  instance_id = element(split(",", aws_cloudformation_stack.exasol_cluster.outputs["Datanodes"]), 0)
}

data "aws_instance" "management_server" {
  instance_id = aws_cloudformation_stack.exasol_cluster.outputs["ManagementServer"]
}

resource "null_resource" "exasol_cluster_wait" {
  count      = var.public_ip ? 1 : 0
  depends_on = [aws_cloudformation_stack.exasol_cluster]

  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
    python3 ${path.module}/scripts/exasol_xmlrpc.py \
      --license-server-address "$IP"\
      --username admin \
      --password "$ADMIN_PASS"
  EOF
    environment = {
      IP         = data.aws_instance.management_server.public_ip
      ADMIN_PASS = var.admin_user_password
    }
  }
}

resource "null_resource" "exasol_waited_on" {
  depends_on = [null_resource.exasol_cluster_wait]
}
