# Developer Guide

## Updating CloudFormation Templates

1. Make a copy of the latest template in `scripts` for the new version
2. Update the new template
3. Upload the template to S3 bucket `exasol-cf-templates` in region `eu-central-1` (prod account), e.g.:
  ```sh
  aws s3 cp scripts/cloudformation_template_v1.1.0.yml s3://exasol-cf-templates/cloudformation_template_v1.1.0.yml
  ```
4. Enable public read access for the uploaded file

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
* Get an Exasol license and store it as `test/simple_exasol_setup/exasolution.lic`
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
