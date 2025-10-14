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
        urls = ["https://github.com/bazelbuild/rules_cc/releases/download/0.0.14/rules_cc-0.0.14.tar.gz"],
        sha256 = "906e89286acc67c20819c3c88b3283de0d5868afda33635d70acae0de9777bb7",
        strip_prefix = "rules_cc-0.0.14",
    )

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

    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "10a0d58f39a1a909e95e00e8ba0b5b1dc64d02997f741151953a2b3659f6e78c",
        strip_prefix = "protobuf-29.0",
        url = "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v29.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "rules_python",
        sha256 = "c6fb25d0ba0246f6d5bd820dd0b2e66b339ccc510242fd4956b9a639b548d113",
        strip_prefix = "rules_python-0.37.2",
        url = "https://github.com/bazelbuild/rules_python/releases/download/0.37.2/rules_python-0.37.2.tar.gz",
    )
