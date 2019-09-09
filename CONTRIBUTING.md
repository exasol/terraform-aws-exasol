# Contributing

Contributions to the Terraform AWS Exasol module are very welcome!

Please feel free to report a bug, suggest an idea for a feature, or ask a
question about the code.

You can create an issue using [Github issues][gh-issues] or follow a standard
[fork and pull][fork-and-pull] process to contribute a code via [Github pull
requests][gh-pulls].

Please keep in mind that contributions are not only pull requests. They can be
any helpful comment on issues, improving documentation, enhancing build process
and many other tasks.

## Pull request process

Once you have found an interesting feature or issue to contribute, you can
follow steps below to submit your patches.

- Fork the repository,
  ```bash
  git clone git@github.com:YOUR-USERNAME/exasol/terraform-aws-exasol.git
  ```
- Create a new feature branch, `git checkout -b "new-feature"`
- Code
- Write tests for changes if possible
- Update documentation if needed
- **Make sure everything is working**, run `./scripts/ci.sh`
- If everything is okay, commit and push to your fork
- [Submit a pull request][submit-pr]
- Let's work together to get your changes reviewed
- Merge into master or development branches

If your commit fixes any particular issue, please specify it in your commit
message as `Fixes issue [issue number]`. For example, `Fixes issue #29`.

Some best practices when creating a pull request:

- Rebase or update
- Squash your commits
- Reword your commits
- Write clear commit messages

You can read more [here][do-pr1] and [here][do-pr2].

[gh-issues]: https://github.com/exasol/terraform-aws-exasol/issues
[gh-pulls]: https://github.com/exasol/terraform-aws-exasol/pulls
[submit-pr]: https://github.com/exasol/terraform-aws-exasol/compare
[fork-and-pull]: https://help.github.com/articles/using-pull-requests/
[do-pr1]: https://www.digitalocean.com/community/tutorials/how-to-create-a-pull-request-on-github
[do-pr2]: https://www.digitalocean.com/community/tutorials/how-to-rebase-and-update-a-pull-request
