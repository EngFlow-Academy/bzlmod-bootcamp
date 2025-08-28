"""Macro for instantiating repos required for core functionality."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def rules_magic_deps():
    maybe(
        http_archive,
        name = "rules_cc",
        urls = ["https://github.com/bazelbuild/rules_cc/releases/download/0.0.14/rules_cc-0.0.14.tar.gz"],
        sha256 = "906e89286acc67c20819c3c88b3283de0d5868afda33635d70acae0de9777bb7",
        strip_prefix = "rules_cc-0.0.14",
    )

    maybe(
        http_archive,
        name = "rules_java",
        urls = [
            "https://github.com/bazelbuild/rules_java/releases/download/8.6.0/rules_java-8.6.0.tar.gz",
        ],
        sha256 = "8475fae7a95463a4fd323a46b0f5601f89863ba019afa358cc9fa1d0e67cdd63",
    )

    maybe(
        http_archive,
        name = "rules_proto",
        sha256 = "8e195dbb6a505ca4c7aafa6b7cffa47fe49a261b27a342053cfb2b973cc4aa12",
        strip_prefix = "rules_proto-7.0.0",
        url = "https://github.com/bazelbuild/rules_proto/releases/download/7.0.0/rules_proto-7.0.0.tar.gz",
    )

    # rules_proto 6.x included this in its deps, but rules_proto 7.x does not.
    # protobuf v29.0 depends on it, but only protobuf >= v30.0 includes it.
    # So we include it for now, but can remove it once protobuf v30.x becomes
    # the minimum supported version.
    maybe(
        http_archive,
        name = "bazel_features",
        sha256 = "95fb3cfd11466b4cad6565e3647a76f89886d875556a4b827c021525cb2482bb",
        strip_prefix = "bazel_features-1.10.0",
        url = "https://github.com/bazel-contrib/bazel_features/releases/download/v1.10.0/bazel_features-v1.10.0.tar.gz",
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
        sha256 = "13e7749c30bc24af6ee93e092422f9dc08491c7097efa69461f88eb5f61805ce",
        strip_prefix = "protobuf-28.0",
        url = "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v28.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "rules_python",
        sha256 = "c6fb25d0ba0246f6d5bd820dd0b2e66b339ccc510242fd4956b9a639b548d113",
        strip_prefix = "rules_python-0.37.2",
        url = "https://github.com/bazelbuild/rules_python/releases/download/0.37.2/rules_python-0.37.2.tar.gz",
    )
