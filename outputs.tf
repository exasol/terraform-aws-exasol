
output "management_server_ip" {
  value = "${aws_cloudformation_stack.exasol_cluster.outputs["ManagementServerPublicIP"]}"
}

output "first_datanode_ip" {
  value = "${data.aws_instance.exasol_first_datanode.public_ip}"
}

output "exasol_waited_on" {
  value = "${null_resource.exasol_waited_on.id}"
}
