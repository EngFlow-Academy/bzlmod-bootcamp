test_build() {
  bazel build //...
}

test_magic_tests() {
  bazel test --test_output=all //...
}
