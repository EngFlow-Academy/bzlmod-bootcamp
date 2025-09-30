#!/usr/bin/env bash

set -euo pipefail

script_file="${BASH_SOURCE[0]}"
project_dir="${script_file%/*}"
if [[ "$project_dir" != "$script_file" ]]; then
  cd "$project_dir"
fi

TEST_FILES=(
  "smoke_tests.sh"
  "emit_values_test.sh"
)
TEST_FILES=("${TEST_FILES[@]/#/test\/}")

usage() {
  local exit_code="$1"
  local out_fd=1
  local padding=''

  if [[ "$exit_code" -ne 0 ]]; then
    out_fd=2
  fi

  printf -v padding "%${#script_file}s" ''
  printf '%s\n' \
    "Usage: ${script_file} [-h | --help] [-v | --verbose] [-k | --keep-going]" \
    "       ${padding} [-f | --file <file>] [-b | --bazel <version>]" \
    "       ${padding} [<test case>]" \
    '' \
    'Where:' \
    '  -h, --help             show this usage message and exit' \
    '  -v, --verbose          show all test output' \
    '  -k, --keep-going       keep running tests even after a test fails' \
    '  -f, --file <file>      run tests from the specified file' \
    '  -b, --bazel <version>  use a specific Bazel version (via Bazelisk)' \
    '  <test case>            run a single test case, showing all output' \
    >&${out_fd}

  exit "$exit_code"
}

error() {
  printf '%s\n\n' "$*" >&2
  usage 1
}

while [[ "$#" -ne 0 ]]; do
  case "$1" in
  -h|--help)
    usage 0
    ;;
  -v|--verbose)
    export RULES_MAGIC_TEST_VERBOSE='true'
    shift
    ;;
  -k|--keep-going)
    export RULES_MAGIC_TEST_KEEP_GOING='true'
    shift
    ;;
  -f|--file)
    if [[ "$#" -lt 2 ]]; then
      error "${1} requires an argument"
    elif [[ ! -r "$2" ]]; then
      error "no such file or inaccessible: ${2}"
    fi
    TEST_FILES=("$2")
    shift 2
    ;;
  -b|--bazel)
    if [[ "$#" -lt 2 ]]; then
      error "${1} requires an argument"
    fi
    export USE_BAZEL_VERSION="$2"
    shift 2
    ;;
  -*)
    error "unknown flag (run with -h for help): ${1}"
    ;;
  *)
    if [[ "$#" -gt 1 ]]; then
      error "${BASH_SOURCE[0]} takes at most one test case argument"
    fi
    export RULES_MAGIC_TEST_ONLY="$1"
    shift
   esac
done

. "../rules_magic/test/test_framework.sh"
echo -e "${BOLD}Bazel version: $(bazel info release 2>/dev/null)${NC}"
run_test_files "${TEST_FILES[@]}"
