#!/usr/bin/env bash
# Inspired by rules_scala's test/shell/test_runner.sh

set -euo pipefail

NC='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

run_test_func() {
  set -euo pipefail

  local test_func="$1"
  local output=""
  local status=0
  local run_direct="${RULES_MAGIC_TEST_ONLY:-}${RULES_MAGIC_TEST_VERBOSE:-}"

  echo "running ${test_func}"

  if [[ -n "$run_direct" ]] && ! "$test_func"; then
    status=1
  else
    output="$($test_func 2>&1)"
    status="$?"
  fi

  if [[ "$status" -ne 0 ]]; then
    echo "$output"
    echo -e "  ${RED}${test_func} failed${NC}"
    return 1
  fi

  echo -e "  ${GREEN}${test_func} successful${NC}"
}

run_test_file() {
    local src_path="$1"
    local test_only="${RULES_MAGIC_TEST_ONLY:-}"

    echo "Executing: ${src_path}"
    . "$src_path"

    while IFS= read -r line; do
      if [[ "$line" =~ ^(_?test_[A-Za-z0-9_]+)\(\)\ ?\{$ ]]; then
        test_func="${BASH_REMATCH[1]}"

        if [[ -n "$test_only" && "$test_only" != "$test_func" ]]; then
          continue
        fi
        : $((++NUM_TESTS))

        if ! run_test_func "$test_func"; then
          FAILURES+=("${test_func} (${src_path})")
        fi
      fi
    done <"$src_path"
}

run_test_files() {
  local NUM_TESTS=0
  local FAILURES=()

  for src_path in "$@"; do
    run_test_file "${src_path}"
  done

  num_failures="${#FAILURES[@]}"

  if [[ "${#FAILURES[@]}" -eq 0 ]]; then
    echo -e $'\n'"${GREEN}${NUM_TESTS} test(s) passed${NC}"
    return
  fi

  echo -e $'\n'"${RED}${num_failures} of ${NUM_TESTS} test(s) failed:${NC}"

  for failed in "${FAILURES[@]}"; do
    echo -e "  ${RED}${failed}${NC}"
  done
  exit "${#FAILURES[@]}"
}
