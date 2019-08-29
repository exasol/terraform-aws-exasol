
variable "project" {
  type = string
}

variable "owner" {
  type = string
}

variable "environment" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "ami_image_name" {
  type = string
}

variable "ami_image_id" {
  type    = string
  default = null
}

variable "database_name" {
  type = string
}

variable "sys_user_password" {
  type = string
}

variable "admin_user_password" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group" {
  type = string
}

variable "public_ips" {
  type = string
  default = true
}

variable "s3_bucket" {
  type = string
  default = true
}

variable "s3_endpoint" {
  type = string
  default = true
}

variable "kms_endpoint" {
  type = string
  default = true
}

variable "ec2_endpoint" {
  type = string
  default = true
}

variable "management_server_instance_type" {
  type = string
}

variable "datanode_count" {
  type = number
}

variable "datanode_instance_type" {
  type = string
}

variable "standbynode_count" {
  type = number
  default = 0
}

variable "key_pair_name" {
  type = string
}

variable "waited_on" {
  type = "string"
}

