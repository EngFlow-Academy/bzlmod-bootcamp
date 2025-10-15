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
# Modeled after:
# - https://github.com/bazel-contrib/rules_scala/blob/v7.1.4/test_dependency_versions.sh
#
# ---
#
# Verifies combinations of supported dependency versions.
#
# Starts by testing the oldest dependency versions, then increments some of them
# to more recent versions. These versions should match the guidance in these
# `README.md` sections:
#
# - Compatible Bazel versions
# - Using a precompiled protocol compiler > Minimum dependency versions
#
# Does not test the latest dependency versions, as all other tests in the suite
# already do this. Only builds with Bzlmod, as `WORKSPACE` builds are now
# considered legacy.

setup_suite() {
  original_dir="$PWD"
  setup_test_tmpdir_for_file "$original_dir" "${BASH_SOURCE[0]##*/}"
  test_tmpdir="$PWD"
}

teardown_suite() {
  teardown_test_tmpdir "$original_dir" "$test_tmpdir"
}

# Explicitly disable this, since this test sets the Bazel version.
export USE_BAZEL_VERSION=""

BZLMOD_BOOTCAMP_TARGETS=(
  "//:example_test"
)

ALL_TARGETS=(
  "//..."
  "${BZLMOD_BOOTCAMP_TARGETS[@]/#/@bzlmod_bootcamp}"
)

do_build_and_test() {
  # These are the minimum supported dependency versions as described in
  # `rules_magic/MODULE.bazel`. Update both if/when a test fails and the
  # appropriate solution is to increase any of these minimum suported versions.
  local bazelversion="7.3.0"
  local protobuf_version="28.0"
  local rules_java_version="7.6.0"
  local bazel_major=""
  local bazel_minor=""
  local current
  local arg

  while [[ "$#" -ne  0 ]]; do
    current="$1"
    shift
    arg="${current#*=}"

    case "$current" in
    --bazelversion=*)
      bazelversion="$arg"
      ;;
    --protobuf=*)
      protobuf_version="$arg"
      ;;
    --rules_java=*)
      rules_java_version="$arg"
      ;;
    esac
  done

  if [[ "$bazelversion" =~ ^([0-9]+)\.([0-9]+)\.[0-9]+.* ]]; then
    bazel_major="${BASH_REMATCH[1]}"
    bazel_minor="${BASH_REMATCH[2]}"
  else
    echo "can't parse --bazelversion: $bazelversion" >&2
    exit 1
  fi

  set -e
  echo "$bazelversion" >.bazelversion

  # Render the MODULE.bazel file and create an empty top level package.
  sed -e "s%\${protobuf_version}%${protobuf_version}%" \
    -e "s%\${rules_java_version}%${rules_java_version}%" \
    "${original_dir}/test/MODULE.bazel.template" >MODULE.bazel
  touch BUILD

  bazel build "${ALL_TARGETS[@]}"
  bazel test --test_output=all "${ALL_TARGETS[@]}"
}

test_minimum_supported_versions() {
  do_build_and_test
}

test_bazel_7_with_rules_java_8() {
  do_build_and_test --rules_java=8.4.0
}

test_bazel_8() {
  do_build_and_test \
    --bazelversion=8.0.0 \
    --protobuf=29.0 \
    --rules_java=8.5.0
}
