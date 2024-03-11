# terraform-aws-exasol 1.0.4, released 2024-03-11

Code name: Fix deployment

## Summary

This release updates the NodeJS version for Lambdas used by the CloudFormation template during deployment to 16.x.

Starting with this version terraform-aws-exasol is tested with Terraform 1.5.7. We recommend using the same version.

## Bug Fixes

- #37: Fixed nodejs version in CF template
