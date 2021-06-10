variable "owner" {}

variable "deputy" {
  default = ""
}

# Use a short project tag. Long tags will case the exasol cluster creation to fail (see https://github.com/exasol/cloudformation-aws-exasol/issues/3)
variable "project" {
  default = "TAE"
}

variable "additional_tags" {
  default = {}
  description = "Additional resource tags"
  type = map(string)
}

variable "exasol_admin_password" {
  default = {}
}

variable "exasol_sys_password" {
  default = {}
}

variable "aws_profile" {
  default = "default"
}