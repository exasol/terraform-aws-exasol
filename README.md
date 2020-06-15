# Exasol AWS Terraform Module

<img alt="terraform-aws-exasol logo" src="docs/images/terraform-aws-exasol_128x128.png" style="float:left; padding:0px 10px 10px 10px;"/>

[![Build Status][travis-badge]][travis-link]
[![GitHub Latest Release][gh-release-badge]][gh-release-link]
![Terraform Version][terraform-version]

A [Terraform](https://www.terraform.io) module to create an
[Exasol](https://www.exasol.com) cluster on [Amazon
AWS](https://aws.amazon.com/).

## Prerequisites

* [terraform][terraform-install] version `>= 0.12`
* [aws-cli profile][aws-cli-profile] with administrative access
* [python3][python3-install]

## Usage example

```hcl
provider "aws" {
  profile     = var.profile
  region      = "eu-central-1"
}

module "exasol" {
  source                          = "exasol/exasol/aws"
  version                         = "<VERSION>"

  cluster_name                    = "exasol-cluster"
  database_name                   = "exadb"
  ami_image_name                  = "R6.2.3-PAYG"
  sys_user_password               = "eXaSol1337DB"
  admin_user_password             = "eXaSol1337OP"
  management_server_instance_type = "m5.xlarge"
  datanode_instance_type          = "m5.2xlarge"
  datanode_count                  = "3"
  standbynode_count               = "0"
  public_ip                       = true

  # These values can be obtained from other modules.
  key_pair_name                   = "exasol-key-pair"
  subnet_id                       = "subnet-ed85b690"
  security_group_id               = "sg-07599522f13906845"

  # Variables used in tags.
  project                         = "exasol-terraformed"
  project_name                    = "exasol-terraformed"
  owner                           = "user@exasol.com"
  environment                     = "dev"
}
```

If you don't already have a vpc and security group you can use:

```hcl
resource "aws_vpc" "exasol_db_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "exa:owner": "user@exasol.com",
    "exa:deputy": "user@exasol.com"
    "exa:project": "exasol-terraformed"
    "exa:project.name": "exasol-terraformed"
    "exa:stage": "development"
    "Name": "VPC for exasol cluster"
  }
}

resource "aws_security_group" "exasol_db_security_group" {
  name = "exasol_cluster_security_group"
  description = "Security group for exasol cluster"
  vpc_id = "${aws_vpc.exasol_db_vpc.id}"

  ingress {
    description = "SSH from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from VPC"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    description = "SQL from VPC"
    from_port = 8563
    to_port = 8563
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    description = "BucketFS"
    from_port = 2580
    protocol = "tcp"
    to_port = 2580
    cidr_blocks = [
      "0.0.0.0/0"]
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
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
   "exa:owner": "user@exasol.com",
   "exa:deputy": "user@exasol.com"
   "exa:project": "exasol-terraformed"
   "exa:project.name": "exasol-terraformed"
   "exa:stage": "development"
   "Name": "VPC for exasol cluster"
  }
}
```

Then you can configure the exasol module like:
```
  subnet_id = aws_subnet.exasol_db_vpc.id
  security_group_id = aws_security_group.exasol_db_security_group.id
```

## Inputs

The following configuration variables are available.

| Variable name                     | Default          | Description
|:----------------------------------|:-----------------|:------------------------------------------------------------------------------------------------|
|``cluster_name``                   |``exasol-cluster``|A name for the to be deployed cluster.                                                           |
|``database_name``                  |``exadb``         |A name of the Exasol database.                                                                   |
|``ami_image_id``                   |``null``          |An Exasol release AMI image id, e.g, `ami-05fad9f0c2609cef0`.                                    |
|``ami_image_name``                 |*<none>*          |An Exasol release AMI image name, e.g, `R6.1.5-PAYG` or `R6.2.1-BYOL`.                           |
|``sys_user_password``              |*<none>*          |An Exasol database `sys` user password.                                                          |
|``admin_user_password``            |*<none>*          |An EXAOperation `admin` user password.                                                           |
|``management_server_instance_type``|``m5.large``      |An EC2 instance type for management server.                                                      |
|``datanode_instance_type``         |``m5.xlarge``     |An EC2 instance type for Exasol datanodes.                                                       |
|``datanode_count``                 |``3``             |The number of Exasol datanodes.                                                                  |
|``standbynode_count``              |``0``             |The number of Exasol standby nodes.                                                              |
|``license``                        |``null``          |An optional path for the Bring Your Own (BYOL) image license file, e.g, `./mor_byol_license.xml`.|
|``public_ip``                      |``true``          |A boolean variable whether to set public IPv4 address to nodes. Skips waiting if set to `false`. |
|``key_pair_name``                  |*<none>*          |An EC2 key pair name to attach to nodes.                                                         |
|``subnet_id``                      |*<none>*          |A subnet id to deploy the Exasol cluster.                                                        |
|``security_group_id``              |*<none>*          |A security group id to attach to nodes. Please ensure that it has correct inbound rules.         |
|``project``                        |``""``            |A name for the project used in resource tagging as ``exa:project`` and ``Project``.              |
|``project_name``                   |``""``            |A name for the project used in resource tagging as ``exa:project.name``                          |
|``owner``                          |``""``            |An email address of the owner used in resource tagging.                                          |
|``environment``                    |``""``            |An environment name to deploy the cluster used in resource tagging.                              |
|``waited_on``                      |``null``          |An optional variable that can include other resource id-s to wait before deploying the cluster.  |

### Remarks

* If the `ami_image_id` is provided it will used. Otherwise, an AMI image id
  will be used corresponding to the provided `ami_image_name` value.
* The `security_group_id` should have at least these ports open for basic
  operations.
  * ``22`` for SSH
  * ``443`` for EXAOperation
  * ``8563`` for Exasol database
  * ``8835`` for Cloud UI
* The `project` input value is also used to create a `exa:project` tag.
* Similarly, the `owner` input value is used to create a `exa:owner` tag.

## Outputs

| Output name                       | Description
|:----------------------------------|:-----------------------------------------------|
|``management_server_ip``           |The Exasol management server public ip address. |
|``first_datanode_ip``              |The first Exasol datanode public ip address.    |

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

[travis-badge]: https://travis-ci.com/exasol/terraform-aws-exasol.svg?branch=master
[travis-link]: https://travis-ci.com/exasol/terraform-aws-exasol
[gh-release-badge]: https://img.shields.io/github/tag/exasol/terraform-aws-exasol.svg?label=latest
[gh-release-link]: https://github.com/exasol/terraform-aws-exasol/releases/latest
[terraform-version]: https://img.shields.io/badge/tf-%3E%3D0.12.0-blue.svg
[terraform-install]: https://www.terraform.io/downloads.html
[aws-cli]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
[aws-cli-profile]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html
[python3-install]: https://www.python.org/downloads/
