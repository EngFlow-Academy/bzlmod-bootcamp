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

_run_emit_values() {
  local result=0

  output="$(bazel run "${@}" //:EmitValues 2>&1)"
  result="$?"

  if [[ -n "${RULES_MAGIC_TEST_VERBOSE:-}" ]]; then
    echo "$output"
  fi
  return "$result"
}

_error() {
  echo -e "${RED}EmitValues ${*}" >&2

  if [[ -z "${RULES_MAGIC_TEST_VERBOSE:-}" ]]; then
    echo -e "Output was:${NC}"$'\n' >&2
    echo "$output" >&2
  fi
  return 1
}

test_uses_default_config_values() {
  local output
  _run_emit_values

  if [[ ! "$output" =~ MAGIC_VERSION:\ 1\.2\.3 ]]; then
    _error "did not use default config values"
  fi
}

test_reads_spells_json() {
  local output
  _run_emit_values

  if [[ ! "$output" =~ frotz ]]; then
    _error "did not read expected spells.json file"
  fi
}

test_uses_config_values_from_repo_env_command_line_option() {
  local output
  _run_emit_values --repo_env=MAGIC_VERSION=4.5.6

  if [[ ! "$output" =~ MAGIC_VERSION:\ 4\.5\.6 ]]; then
    _error "did not use config values from --repo_env"
  fi
}

test_uses_different_toolchain_based_on_game() {
  local output
  _run_emit_values --repo_env=MAGIC_GAME=spellbreaker

  if [[ ! "$output" =~ gloth ]]; then
    _error "did not use spellbreaker toolchain as the default"
  fi
}

test_uses_toolchain_from_extra_toolchains_command_line_option() {
  local toolchain='@rules_magic//magic:spellbreaker_toolchain'
  local output
  _run_emit_values "--extra_toolchains=${toolchain}"

  if [[ ! "$output" =~ snavig ]]; then
    _error "did not use spellbreaker toolchain as the default"
  fi
}

test_fail_if_default_version_not_in_versions_list() {
  local output

  if _run_emit_values --repo_env=MAGIC_VERSION=3.2.1; then
    _error "did not fail on misconfigured MAGIC_VERSION"
  elif [[ ! "$output" =~ default\ version\ \(3\.2\.1\) ]]; then
    _error "output did not contain default version in failure message"
  fi
}

test_fail_if_default_game_not_in_games_list() {
  local output

  if _run_emit_values --repo_env=MAGIC_GAME=deadline; then
    _error "did not fail on misconfigured MAGIC_GAME"
  elif [[ ! "$output" =~ default\ game\ \(deadline\) ]]; then
    _error "output did not contain default game in failure message"
  fi
}
