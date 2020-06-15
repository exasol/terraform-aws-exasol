
variable "cluster_name" {
  default     = "exasol-cluster"
  description = "A name for the to be deployed cluster."
  type        = string
}

variable "database_name" {
  default     = "exadb"
  description = "A name of the Exasol database."
  type        = string
}

variable "ami_image_name" {
  description = "An Exasol AMI image name. For example, 'R6.1.5-PAYG' or 'R6.2.1-BYOL'."
  type        = string
}

variable "ami_image_id" {
  default     = null
  description = "An Exasol AMI image id. For example, 'ami-05fad9f0c2609cef0'."
  type        = string
}

variable "ami_image_owner" {
  default     = "679593333241"
  description = "An Exasol AMI image release owner."
  type        = string
}

variable "sys_user_password" {
  description = "An Exasol database `sys` user password (format: lowercase, uppercase, digit, 8-20 length)."
  type        = string
}

variable "admin_user_password" {
  description = "An EXAOperation `admin` user password (format: lowercase, uppercase, digit, 8-20 length)."
  type        = string
}

variable "subnet_id" {
  description = "A subnet id to use when deploying Exasol cluster."
  type        = string
}

variable "security_group_id" {
  description = "A security group id to attach to the intances."
  type        = string
}

variable "public_ip" {
  default     = true
  description = "Whether to associate public ip addresses to all instances."
  type        = string
}

variable "create_s3_bucket" {
  default     = true
  description = "Whether to create S3 bucket for a default backup location."
  type        = string
}

variable "create_s3_endpoint" {
  default     = false
  description = "Whether to create S3 endpoint. Set to false if instances are publicly available or if S3 endpoint already exists."
  type        = string
}

variable "create_kms_endpoint" {
  default     = false
  description = "Whether to create AWS KMS endpoint. Set to false if instances are publicly available or if KMS endpoint already exists."
  type        = string
}

variable "create_ec2_endpoint" {
  default     = false
  description = "Whether to create EC2 endpoint. Set to false if instances are publicly available or if EC2 endpoint already exists."
  type        = string
}

variable "open_ports" {
  default     = "20,22,443,6583,8563,8835"
  description = "A comma separated list of open ports or port ranges."
  type        = string
}

variable "license" {
  default     = null
  description = "A path to license file that can be used with Bring Your Own License (BYOL) installation."
  type        = string
}

variable "management_server_instance_type" {
  default     = "m5.large"
  description = "An EC2 instance type for the Exasol management server."
  type        = string
}

variable "datanode_instance_type" {
  default     = "m5.xlarge"
  description = "An EC2 instance type for the Exasol datanodes."
  type        = string
}

variable "datanode_count" {
  default     = 3
  description = "The number of datanodes that store data and process queries (min: 1, max: 64)."
  type        = number
}

variable "standbynode_count" {
  default     = 0
  description = "The number of standby nodes that can automatically replace a failed node."
  type        = number
}

variable "key_pair_name" {
  description = "An EC2 key pair name to attach to the instances."
  type        = string
}

variable "project" {
  default     = ""
  description = "A name of the project. Also used in tags."
  type        = string
}

variable "project_name" {
  default     = ""
  description = "A readable name of the project. Also used in tags."
  type        = string
}

variable "owner" {
  default     = ""
  description = "An email address of the owner. Also used in tags."
  type        = string
}

variable "environment" {
  default     = ""
  description = "An environment name to deploy the cluster. Also used in tags."
  type        = string
}

variable "waited_on" {
  default     = null
  description = "A variable that this module can wait on."
  type        = string
}

