"""Macro for instantiating repos required for core functionality."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def rules_magic_deps():
    maybe(
        http_archive,
        name = "rules_java",
        url = "https://github.com/bazelbuild/rules_java/releases/download/5.4.0/rules_java-5.4.0.tar.gz",
        sha256 = "9b87757af5c77e9db5f7c000579309afae75cf6517da745de01ba0c6e4870951",
    )

    maybe(
        http_archive,
        name = "rules_proto",
        sha256 = "dc3fb206a2cb3441b485eb1e423165b231235a1ea9b031b4433cf7bc1fa460dd",
        strip_prefix = "rules_proto-5.3.0-21.7",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_proto/archive/refs/tags/5.3.0-21.7.tar.gz",
            "https://github.com/bazelbuild/rules_proto/archive/refs/tags/5.3.0-21.7.tar.gz",
        ],
    )
