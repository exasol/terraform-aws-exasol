
output "management_server_ip" {
  value = data.aws_instance.management_server.public_ip
}

output "first_datanode_ip" {
  value = data.aws_instance.exasol_first_datanode.public_ip
}

output "exasol_waited_on" {
  value = null_resource.exasol_waited_on.id
}
