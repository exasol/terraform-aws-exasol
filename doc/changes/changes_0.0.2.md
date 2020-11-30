# terraform-aws-exasol 0.0.2, released 2020-01-21

## Summary

* Updates to the latest cloudformation template.
  [#2](https://github.com/exasol/terraform-aws-exasol/issues/2)
  [#3](https://github.com/exasol/terraform-aws-exasol/pull/3)

* The most notable changes in the new cloudformation template are as below:
  - Attached EBS volumes are encrypted by default is true.
  - New additional open port by default: `20`.
  - The size of block device by default is `345` (previously `172`).
  - The number of block devices by default are `4` (previously `1`).
  - The default Lambda nodejs runtime is with version `12.x` (previously `8.x`).

* Updates readme with additional information and fix typos.
  - Adds BYOL and license parameters to variable inputs on the README.
  - Fixes minor typos, e.g, `security_group` -> `security_group_id`.
  - Updates `tflint` version to `v0.13.4`.

* Adds variable for license file path in order to use with Bring Your Own (BYOL)
  Exasol machine images.