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

test_receives_default_config_values() {
  local output
  _run_emit_values

  if [[ ! "$output" =~ MAGIC_VERSION:\ 1\.2\.3 ]]; then
    _error "did not receive default config values"
  fi
}

test_reads_spells_json() {
  local output
  _run_emit_values

  if [[ ! "$output" =~ frotz ]]; then
    _error "did not read expected spells.json file"
  fi
}

test_receives_overridden_config_values() {
  local output
  _run_emit_values --repo_env=MAGIC_VERSION=4.5.6

  if [[ ! "$output" =~ MAGIC_VERSION:\ 4\.5\.6 ]]; then
    _error "did not receive overridden config values"
  fi
}

test_uses_different_toolchain_based_on_game() {
  local output
  _run_emit_values --repo_env=MAGIC_GAME=spellbreaker

  if [[ ! "$output" =~ gloth ]]; then
    _error "did not use spellbreaker toolchain as the default"
  fi
}

test_uses_toolchain_from_command_line() {
  local toolchain='@rules_magic_toolchains//spells:spellbreaker_toolchain'
  local output
  _run_emit_values "--extra_toolchains=${toolchain}"

  if [[ ! "$output" =~ snavig ]]; then
    _error "did not use spellbreaker toolchain as the default"
  fi
}

test_fail_if_magic_version_not_in_versions_list() {
  local output

  if _run_emit_values --repo_env=MAGIC_VERSION=3.2.1; then
    _error "did not fail on misconfigured magic version"
  elif [[ ! "$output" =~ default\ magic\ version\ .3\.2\.1. ]]; then
    _error "output did not contain default magic version in failure message"
  fi
}

test_fail_if_unknown_game() {
  local output

  if _run_emit_values --repo_env=MAGIC_GAME=deadline; then
    _error "did not fail on unknown game"
  elif [[ ! "$output" =~ (default|unknown)\ game\ .deadline. ]]; then
    _error "output did not contain default game in failure message"
  fi
}
