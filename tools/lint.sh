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

set -euo pipefail

script_file="${BASH_SOURCE[0]}"
project_dir="${script_file%/*}"
if [[ "$project_dir" != "$script_file" ]]; then
  cd "$project_dir"
fi
cd '..'

BUILDIFIER_URL_ROOT='https://github.com/bazelbuild/buildtools/blob/v8.2.1'
MODE='warn'
PATHS=('.')

# Suppress the `native-java-*` warnings because we'll fix the related issues
# later in the `bazel-9 branch`.
WARNINGS='+unsorted-dict-items,-native-java-common,-native-java-info'

usage() {
  local exit_code="$1"
  local out_fd=1
  local padding=''

  if [[ "$exit_code" -ne 0 ]]; then
    out_fd=2
  fi

  printf -v padding "%${#script_file}s" ''
  printf '%s\n' \
    "Usage: ${script_file} [-h | --help] [-f | --fix]" \
    "       ${padding} [-w | --warnings <warnings>] [<path>...]" \
    '' \
    'Runs buildifier on the specified files and directories.' \
    '' \
    'Where:' \
    '  -h, --help  show this usage message and exit' \
    '  -f, --fix   allow buildifier to apply fixes where possible' \
    '  <warnings>  buildifier warnings to include; defaults to:' \
    "                ${WARNINGS}" \
    '  <path>      file/directory to process (defaults to project root)' \
    '' \
    'For more information on buildifier and its warnings:' \
    "- ${BUILDIFIER_URL_ROOT}/buildifier/README.md" \
    "- ${BUILDIFIER_URL_ROOT}/WARNINGS.md" \
    >&${out_fd}

  exit "$exit_code"
}

while [[ "$#" -ne 0 ]]; do
  case "$1" in
  -h|--help)
    usage 0
    ;;
  -f|--fix)
    MODE='fix'
    shift
    ;;
  -w|--warnings)
    WARNINGS="$2"
    shift 2
    ;;
  -*)
    error "unknown flag (run with -h for help): ${1}"
    ;;
  *)
    PATHS=("$@")
    shift "$#"
    ;;
  esac
done

if ! command -v buildifier >/dev/null; then
  printf 'Please install buildifier before running this script.\n' >&2
  exit 1
fi

exec buildifier -r -v -lint "$MODE" -warnings "$WARNINGS" "${PATHS[@]}"
