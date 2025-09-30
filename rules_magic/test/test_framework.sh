#!/usr/bin/env bash
#
# Copyright 2025 EngFlow, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ---
#
# Inspired by:
# - https://github.com/bazel-contrib/rules_scala/blob/v7.1.4/test/shell/test_runner.sh

set -euo pipefail

NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BOLD='\033[1m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_RED='\033[1;31m'

_add_duration_segment() {
    local divisor=$1
    local unit="$2"

    if [[ $total -ge $divisor ]]; then
      result+=("$((total / divisor))${unit}")
      total=$((total % divisor))
    fi
}

duration_since() {
    local total=$(($SECONDS - $1)) # SECONDS is a special Bash variable
    local result=()

    _add_duration_segment 86400 d
    _add_duration_segment 3600 h
    _add_duration_segment 60 m
    result+=("${total}s")
    printf '%s' "${result[*]}"
}

run_test_func() {
  set -euo pipefail

  local test_func="$1"
  local output=""
  local status=0
  local run_direct="${RULES_MAGIC_TEST_ONLY:-}${RULES_MAGIC_TEST_VERBOSE:-}"
  local start=0
  local duration=""

  echo "running ${test_func}"
  start=$SECONDS  # SECONDS is a special Bash variable

  if [[ -n "$run_direct" ]] && ! "$test_func"; then
    status=1
  else
    output="$($test_func 2>&1)"
    status="$?"
  fi

  duration="($(duration_since $start))"

  if [[ "$status" -ne 0 ]]; then
    echo "$output"
    echo -e "  ${RED}${test_func} failed ${duration}${NC}"
    return 1
  fi

  echo -e "  ${GREEN}${test_func} successful ${duration}${NC}"
}

run_test_file() {
    local src_path="$1"
    local test_only="${RULES_MAGIC_TEST_ONLY:-}"
    local test_funcs=()
    if [[ ! -r "$src_path" ]]; then
      FAILURES+=("Test file not found or permission denied: ${src_path}")
      return 1
    fi

    while IFS= read -r line; do
      if [[ "$line" =~ ^(_?test_[A-Za-z0-9_]+)\(\)\ ?\{$ ]]; then
        test_func="${BASH_REMATCH[1]}"

        if [[ -z "$test_only" || "$test_only" == "$test_func" ]]; then
          test_funcs+=("$test_func")
        fi
      fi
    done <"$src_path"

    if [[ "${#test_funcs[@]}" -eq 0 ]]; then
      return
    fi

    echo -e $'\n'"${BOLD}File: ${src_path}${NC}"
    . "$src_path"

    for test_func in "${test_funcs[@]}"; do
      if [[ "${test_func:0:1}" == '_' ]]; then
        echo -e "${YELLOW}skipping ${test_func}${NC}"
        SKIPPED+=("${test_func} (${src_path})")
        continue
      fi

      : $((++NUM_TESTS))

      if ! run_test_func "$test_func"; then
        FAILURES+=("${test_func} (${src_path})")

        if [[ -z "${RULES_MAGIC_TEST_KEEP_GOING:-}" ]]; then
          return 1
        fi
      fi
    done
}

_print_test_list() {
  local bold_color="$1"
  local msg="$2"
  local color="$3"
  shift 3
  local num_tests="$#"

  if [[ $# -ne 0 ]]; then
    echo -e "${bold_color}${num_tests} test(s) ${msg}:${color}"
    printf '  %s\n' "$@"
    echo -e "${NC}"
  fi
}

run_test_files() {
  local NUM_TESTS=0
  local SKIPPED=()
  local FAILURES=()
  local duration=""
  local start=$SECONDS  # SECONDS is a special Bash variable

  for src_path in "$@"; do
    if ! run_test_file "${src_path}"; then
      break
    fi
  done

  duration="$(duration_since $start)"
  echo ''

  _print_test_list "$BOLD_YELLOW" 'skipped' "$YELLOW" "${SKIPPED[@]}"

  if [[ ${#FAILURES[@]} -eq 0 ]]; then
    echo -e "${BOLD_GREEN}${NUM_TESTS} test(s) passed in ${duration}${NC}"
  else
    printf '%b' "${BOLD_GREEN}${NUM_TESTS} test(s) passed, "
    _print_test_list "$BOLD_RED" "failed in ${duration}" "$RED" "${FAILURES[@]}"
    return ${#FAILURES[@]}
  fi
}
