# terraform-aws-exasol 1.0.3, released 2022-06-27

Code name: Fix deployment

## Summary

This release updates the NodeJS version for Lambdas used by the CloudFormation template during deployment.

Starting with this version terraform-aws-exasol is tested with Terraform 1.5.1. We recommend using the same version.

## Bug Fixes

- #29: Added name to workflow files with matrix builds
- #32: Fixed nodejs version in CF template
