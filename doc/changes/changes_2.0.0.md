# terraform-aws-exasol 2.0.0, released 2024-09-27

Code name: Update CloudFormation template and new DB version

## Summary

This release updates the NodeJS version for Lambdas used by the CloudFormation template during deployment to 20.x.

### Breaking Change

The "Bring your Own License" (BYOL) AMI images are deprecated and not available any more. Specifying your own license file is not possible any more. Please use the "Pay as you go" (PAYG) AMI images, e.g. `Exasol-R7.1.26-PAYG`.

## Bug Fixes

- #39: Fixed nodejs version in CF template
