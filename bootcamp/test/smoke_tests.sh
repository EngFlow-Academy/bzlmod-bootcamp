test_build() {
  bazel build //...
}

test_magic_tests() {
  bazel test --test_output=all \
    --test_env=RULES_MAGIC_TEST_VERBOSE="${RULES_MAGIC_TEST_VERBOSE:-}" \
    //...
}
