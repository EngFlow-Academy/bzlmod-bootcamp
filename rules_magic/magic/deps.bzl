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

"""Macro for instantiating repos required for core functionality."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def rules_magic_deps():
    """Instantiate dependency repositories required for core functionality."""
    maybe(
        http_archive,
        name = "rules_cc",
        sha256 = "5287821524d1c1d20f1c0ffa90bd2c2d776473dd8c84dafa9eb783150286d825",
        strip_prefix = "rules_cc-0.2.11",
        url = "https://github.com/bazelbuild/rules_cc/releases/download/0.2.11/rules_cc-0.2.11.tar.gz",
    )

    maybe(
        http_archive,
        name = "rules_java",
        urls = [
            "https://github.com/bazelbuild/rules_java/releases/download/8.16.1/rules_java-8.16.1.tar.gz",
        ],
        sha256 = "1b30698d89dccd9dc01b1a4ad7e9e5c6e669cdf1918dbb050334e365b40a1b5e",
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

    # The Bazel 9 build requires protobuf >= 32.0 in MODULE.bazel to avoid
    # warnings. However, protobuf v30 removes py_proto_library from its
    # //protobuf.bzl file, which the @bazel_tools//src/main/protobuf package
    # requires. After the upcoming "Replace @bazel_tools with @bazel_worker_api"
    # commit, we can bump this to a newer version. See: bazelbuild/bazel#26579.
    #
    # Also, protobuf v32 explicitly breaks Bazel 6 compatibility. Bazel 9 drops
    # the legacy WORKSPACE model completely, so we'll eventually update to the
    # latest protobuf version that still supports Bazel 6. If you don't care
    # about Bazel 6 compatibility, bump this to the same version as in
    # MODULE.bazel. (Again, after the upcoming @bazel_worker_api commit.)
    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "955ef3235be41120db4d367be81efe6891c9544b3a71194d80c3055865b26e09",
        strip_prefix = "protobuf-29.5",
        url = "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v29.5.tar.gz",
    )

    # Required by Bazel 8.3.0 and above, since the legacy WORKSPACE suffix loads
    # `@bazel_features//:deps.bzl` but doesn't instantiate the `@bazel_features` repo.
    # - https://github.com/bazelbuild/bazel/commit/0e528d037e041ea754e4420de6b4c9f2e502b57e
    # - https://github.com/bazelbuild/bazel/blob/8.4.2/src/main/java/com/google/devtools/build/lib/bazel/rules/BUILD#L136-L137
    maybe(
        http_archive,
        name = "bazel_features",
        sha256 = "a660027f5a87f13224ab54b8dc6e191693c554f2692fcca46e8e29ee7dabc43b",
        strip_prefix = "bazel_features-1.30.0",
        url = "https://github.com/bazel-contrib/bazel_features/releases/download/v1.30.0/bazel_features-v1.30.0.tar.gz",
    )

    # Required by protobuf >= v29.0. Invoking `bazel_features_deps()` first
    # instantiates v1.6.1, which lacks `paths.is_normalized()`.
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "d00f1389ee20b60018e92644e0948e16e350a7707219e7a390fb0a99b6ec9262",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.7.0/bazel-skylib-1.7.0.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.7.0/bazel-skylib-1.7.0.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "rules_python",
        sha256 = "9f9f3b300a9264e4c77999312ce663be5dee9a56e361a1f6fe7ec60e1beef9a3",
        strip_prefix = "rules_python-1.4.1",
        url = "https://github.com/bazel-contrib/rules_python/releases/download/1.4.1/rules_python-1.4.1.tar.gz",
    )
