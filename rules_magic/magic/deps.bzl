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
    maybe(
        http_archive,
        name = "rules_java",
        urls = [
            "https://github.com/bazelbuild/rules_java/releases/download/7.10.0/rules_java-7.10.0.tar.gz",
        ],
        sha256 = "eb5447f019734b0c4284eaa5f8248415084da5445ba8201c935a211ab8af43a0",
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
