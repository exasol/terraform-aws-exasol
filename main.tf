
data "aws_ami" "exasol" {
  most_recent = true
  owners = ["self"]

  filter {
    name   = "name"
    values = ["${var.ami_image_name}"]
  }
}

resource "aws_cloudformation_stack" "exasol_cluster" {
  name          = var.cluster_name
  capabilities  = ["CAPABILITY_IAM"]
  on_failure    = "DELETE"
  template_url  = "https://mo-test-cf-templates.s3.eu-central-1.amazonaws.com/cloudformation_template_v0.2.0.yml"

  parameters = {
    DBSystemName              = var.database_name
    DBPassword                = var.sys_user_password
    ExasolPassword            = var.admin_user_password
    SubnetId                  = var.subnet_id
    DBSecurityGroup           = var.security_group
    LicenseServerInstanceType = var.management_server_instance_type
    DatabaseNodeInstanceType  = var.datanode_instance_type
    DBNodeCount               = var.datanode_count
    StandbyNode               = var.standbynode_count
    KeyName                   = var.key_pair_name
    ImageId                   = var.ami_image_id == null ? var.ami_image_id : data.aws_ami.exasol.id
    PublicIP                  = var.public_ips
  }

  tags = {
    Name          = "exasol-${var.cluster_name}-${var.environment}"
    Project       = var.project
    "exa:project" = var.project
    Owner         = var.owner
    "exa:owner"   = var.owner
    Environment   = var.environment
    WaitedOn      = "${var.waited_on}"
  }
}

data "aws_instance" "exasol_first_datanode" {
  instance_id = "${element(split(",", aws_cloudformation_stack.exasol_cluster.outputs["Datanodes"]), 0)}"
}

resource "null_resource" "exasol_cluster_wait" {
  depends_on = ["aws_cloudformation_stack.exasol_cluster"]

  triggers = {
    always = "${uuid()}"
  }

  provisioner "local-exec" {
    command = <<EOF
    python3 ${path.module}/scripts/exasol_xmlrpc.py \
      --license-server-address \
      ${aws_cloudformation_stack.exasol_cluster.outputs["ManagementServerPublicIP"]} \
      --username admin \
      --password ${var.admin_user_password} \
      --buckets artifacts
  EOF
  }
}

resource "null_resource" "exasol_waited_on" {
  depends_on = ["null_resource.exasol_cluster_wait"]
}
