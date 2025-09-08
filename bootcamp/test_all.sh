#!/usr/bin/env bash

set -euo pipefail

project_dir="${BASH_SOURCE[0]%/*}"
if [[ "$project_dir" != "${BASH_SOURCE[0]}" ]]; then
  cd "$project_dir"
fi

. "../rules_magic/test/test_framework.sh"
run_test_files ./test/*.sh
