# Developer Guide

## System Tests

System tests for deploying the Exasol Terraform module are located in the `test` directory.

### Running System Tests

* Install Terraform and Go
* Get an Exasol license and store it as `test/simple_exasol_setup/exasolution.lic`
* Create the file `test/simple_exasol_setup/terraform.tfvars` and fill in:
  ```
  owner = "<YOUR_EMAIL>"
  aws_profile = "<AWS PROFILE TO USE>"
  ```
* Run `cd test && go test --timeout 2h`

## Publishing to Terraform Registry

To publish the module to the Terraform registry just create a release in the GitHub repository.

The new version will automatically be available at [exasol/exasol/aws](https://registry.terraform.io/modules/exasol/exasol/aws/latest) in the registry.
