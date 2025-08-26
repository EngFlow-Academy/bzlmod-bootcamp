"""Macro for instantiating repos required for core functionality."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def rules_magic_deps():
    maybe(
        http_archive,
        name = "rules_java",
        urls = [
            "https://github.com/bazelbuild/rules_java/releases/download/7.10.0/rules_java-7.10.0.tar.gz",
        ],
        sha256 = "eb5447f019734b0c4284eaa5f8248415084da5445ba8201c935a211ab8af43a0",
    )

    maybe(
        http_archive,
        name = "rules_proto",
        sha256 = "6fb6767d1bef535310547e03247f7518b03487740c11b6c6adb7952033fe1295",
        strip_prefix = "rules_proto-6.0.2",
        url = "https://github.com/bazelbuild/rules_proto/releases/download/6.0.2/rules_proto-6.0.2.tar.gz",
    )

    # Needed by Bazel 6.5.0 to compile protobuf without C++14 flags in .bazelrc.
    #maybe(
    #    http_archive,
    #    name = "com_google_absl",
    #    sha256 = "91ac87d30cc6d79f9ab974c51874a704de9c2647c40f6932597329a282217ba8",
    #    strip_prefix = "abseil-cpp-20220623.1",
    #    url = "https://github.com/abseil/abseil-cpp/archive/refs/tags/20220623.1.tar.gz",
    #)

    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "e4ff2aeb767da6f4f52485c2e72468960ddfe5262483879ef6ad552e52757a77",
        strip_prefix = "protobuf-27.2",
        url = "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v27.2.tar.gz",
    )

    maybe(
        http_archive,
        name = "rules_python",
        sha256 = "c6fb25d0ba0246f6d5bd820dd0b2e66b339ccc510242fd4956b9a639b548d113",
        strip_prefix = "rules_python-0.37.2",
        url = "https://github.com/bazelbuild/rules_python/releases/download/0.37.2/rules_python-0.37.2.tar.gz",
    )
