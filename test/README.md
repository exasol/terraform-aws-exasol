# Tests for terraform-aws-exasol

This directory contains tests for the Exasol terraform module.

## Usage:

* Install Terraform and Go
* Get a exasol license and store it as `simple_exasol_setup/exasol.lic`
* Create the file `simple_exasol_setup/terraform.tfvars` and fill in:
  ```
  owner = "<YOUR_EMAIL>"
  aws_profile = "<AWS PROFILE TO USE>"
  ```
* Run `go test --timeout 2h`
