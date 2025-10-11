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

"""Macro for instantiating the latest versions of required dependencies."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//magic:private/bazel_worker_api.bzl", "bazel_worker_api")

def rules_magic_deps():
    """Instantiate the latest dependencies required for core functionality."""
    maybe(
        http_archive,
        name = "rules_java",
        urls = [
            "https://github.com/bazelbuild/rules_java/releases/download/9.0.3/rules_java-9.0.3.tar.gz",
        ],
        sha256 = "865b3d334bd0f769587737447410d8042d6a95134cc45be5380805fdbacd7152",
    )

    # Required by rules_java >= 8.16.0:
    # - https://github.com/bazelbuild/rules_java/releases/tag/8.16.0
    maybe(
        http_archive,
        name = "bazel_features",
        sha256 = "07271d0f6b12633777b69020c4cb1eb67b1939c0cf84bb3944dc85cc250c0c01",
        strip_prefix = "bazel_features-1.38.0",
        url = "https://github.com/bazel-contrib/bazel_features/releases/download/v1.38.0/bazel_features-v1.38.0.tar.gz",
    )

    # We need to instantiate `bazel_features` >= 1.30.0 and invoke
    # `bazel_features_deps` before `rules_java_deps` for `rules_java` >= 8.16.0.
    # This means we also invoke it before `protobuf_deps`.
    #
    # However, `bazel_features_deps` from 1.30.0 instantiates `bazel_skylib`
    # 1.6.1, and `protobuf` >= v29.0 requires `bazel_skylib` >= 1.7.0. So we
    # instantiate `bazel_skylib` here instead.
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "6e78f0e57de26801f6f564fa7c4a48dc8b36873e416257a92bbb0937eeac8446",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.8.2/bazel-skylib-1.8.2.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.8.2/bazel-skylib-1.8.2.tar.gz",
        ],
    )

    # The Bazel 9 build requires protobuf >= 32.0 in MODULE.bazel to avoid
    # warnings. protobuf v30 removed py_proto_library its //protobuf.bzl file,
    # which the @bazel_tools//src/main/protobuf package requires. But since
    # we've replaced the @bazel_tools dependency with @bazel_worker_api, we can
    # bump this to a newer version. See: bazelbuild/bazel#26579.
    #
    # Also, protobuf v32 explicitly breaks Bazel 6 compatibility. Bazel 9 drops
    # the legacy WORKSPACE model completely, so we use the latest protobuf
    # version that still supports Bazel 6. If you don't care about Bazel 6
    # compatibility, bump this to the same version as in MODULE.bazel.
    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "c3a0a9ece8932e31c3b736e2db18b1c42e7070cd9b881388b26d01aa71e24ca2",
        strip_prefix = "protobuf-31.1",
        url = "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v31.1.tar.gz",
    )

    bazel_worker_api()
