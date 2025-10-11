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

"""Macro for instantiating the oldest versions of required dependencies."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//magic:private/bazel_worker_api.bzl", "bazel_worker_api")

def rules_magic_deps():
    """Instantiate oldest dependencies required for core functionality."""

    # Technically, we could support `rules_java` 7.10.0, maybe earlier versions.
    # But the legacy `WORKSPACE` setup is different from `rules_java` 8.5.0, so
    # we keep 8.5.0 here. This enables swapping this file with `latest_deps.bzl`
    # in the legacy `WORKSPACE` file without changing the `rules_java` setup
    # macro calls.
    maybe(
        http_archive,
        name = "rules_java",
        urls = [
            "https://github.com/bazelbuild/rules_java/releases/download/8.5.0/rules_java-8.5.0.tar.gz",
        ],
        sha256 = "5c215757b9a6c3dd5312a3cdc4896cef3f0c5b31db31baa8da0d988685d42ae4",
    )

    # Uncomment to compile protobuf using Bazel 6.5.0 without the C++17 flags in
    # .bazelrc-cxxopts.
    #maybe(
    #    http_archive,
    #    name = "com_google_absl",
    #    sha256 = "91ac87d30cc6d79f9ab974c51874a704de9c2647c40f6932597329a282217ba8",
    #    strip_prefix = "abseil-cpp-20220623.1",
    #    url = "https://github.com/abseil/abseil-cpp/archive/refs/tags/20220623.1.tar.gz",
    #)

    # This is the lowest version that works with `bazel_worker_api`, macOS 26,
    # and Xcode 26, as described in previous commits. Bazel 8 builds in legacy
    # `WORKSPACE` mode require `protobuf` >= v29.
    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "13e7749c30bc24af6ee93e092422f9dc08491c7097efa69461f88eb5f61805ce",
        strip_prefix = "protobuf-28.0",
        url = "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v28.0.tar.gz",
    )

    # Required by Bazel 8 after 8.3.0, since the legacy WORKSPACE suffix loads
    # `@bazel_features//:deps.bzl` but doesn't instantiate the `@bazel_features` repo.
    #
    # - https://github.com/bazelbuild/bazel/commit/0e528d037e041ea754e4420de6b4c9f2e502b57e
    # - https://github.com/bazelbuild/bazel/blob/8.4.2/src/main/java/com/google/devtools/build/lib/bazel/rules/BUILD#L136-L137
    #
    # Bazel 8 won't build without `protobuf` >= v29, so technically we don't
    # need to instantiate our own `bazel_features` repo. As with `rules_java`
    # 8.5.0, this enables swapping this file with `latest_deps.bzl` without
    # removing `bazel_features_deps` from the legacy `WORKSPACE` file.
    maybe(
        http_archive,
        name = "bazel_features",
        sha256 = "95fb3cfd11466b4cad6565e3647a76f89886d875556a4b827c021525cb2482bb",
        strip_prefix = "bazel_features-1.10.0",
        url = "https://github.com/bazel-contrib/bazel_features/releases/download/v1.10.0/bazel_features-v1.10.0.tar.gz",
    )

    bazel_worker_api()
