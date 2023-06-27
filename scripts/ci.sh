#!/usr/bin/env bash

set -o errtrace -o nounset -o pipefail -o errexit

# Goto parent (base) directory of this script.
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )"
cd "$BASE_DIR"

REGION='eu-central-1'
export AWS_REGION=${REGION}

run_terraform_init () {
  terraform init
}

run_terraform_fmt () {
    if ! terraform fmt -check=true .
    then
      echo "terraform fmt failed!"
      terraform fmt -check=true -diff .
      exit 1
    fi
}

run_terraform_validate () {
  terraform validate
}

run_tflint () {
  tflint --chdir=.
}

run_clean_worktree_check () {
  # To be executed after all other steps, to ensures that there is no
  # uncommitted code and there are no untracked files, which means
  # .gitignore is complete and all code is part of a reviewable commit.
  GIT_STATUS="$(git status --porcelain)"
  if [[ $GIT_STATUS ]]; then
    echo "Your worktree is not clean,"
    echo "there is either uncommitted code or there are untracked files:"
    echo "${GIT_STATUS}"
    exit 1
  fi
}

run_terraform_init
run_terraform_fmt
run_terraform_validate
run_tflint
run_clean_worktree_check
