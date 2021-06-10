# terraform-aws-exasol 1.0.1, released 2020-12-08

Code name: Security fix

## Summary

In this release we fixed a security issue. By an unquoted password it was
possible to execute code on the host running terraform.

## Refactoring

* #23: Added integration test

## Bugfixes

* #21: Fixed unescaped password
