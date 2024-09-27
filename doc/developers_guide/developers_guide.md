# Developer Guide

## Updating CloudFormation Templates

1. Make a copy of the latest template in `scripts` for the new version
2. Update the new template
3. Upload the template to S3 bucket `exasol-cf-templates` in region `eu-central-1` (prod account) and re-enable public read access:
  ```sh
  version=v2.0.0
  aws s3 cp scripts/cloudformation_template_${version}.yml s3://exasol-cf-templates/cloudformation_template_${version}.yml
  aws s3api put-object-acl --bucket exasol-cf-templates --key cloudformation_template_${version}.yml --acl public-read
  ```


## CI Tests

The CI build runs smoke tests and static code analysis. This requires Terraform and [tflint](https://github.com/terraform-linters/tflint) to be installed.

Run the build with the following command:

```sh
./scripts/ci.sh
```

## System Tests

System tests for deploying the Exasol Terraform module are located in the `test` directory.

### Running System Tests

* Install Terraform and Go
* Create the file `test/simple_exasol_setup/terraform.tfvars` and fill in:
  ```properties
  owner = "<YOUR_EMAIL>"
  aws_profile = "<AWS PROFILE TO USE>"
  ```
* Run
  ```sh
  cd test
  go test --timeout 2h
  ```

## Publishing to Terraform Registry

To publish the module to the Terraform registry create a release in the GitHub repository.

The new version will automatically be available at [exasol/exasol/aws](https://registry.terraform.io/modules/exasol/exasol/aws/latest) in the registry.
