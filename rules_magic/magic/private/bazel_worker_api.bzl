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

"""Function instantiating the @bazel_worker_api repo.

Shared between //magic:deps.bzl and //magic:latest_deps.bzl.

Note that the shared Bazel worker proto definition from `@bazel_worker_api` is
a completely internal detail that shouldn't really affect users. Newer
protocol buffer versions are generally compatible with older versions. For
that reason, //magic:deps.bzl and //magic:latest_deps.bzl both use
`bazel_worker_api` to instantiate the same `@bazel_worker_api` version.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def bazel_worker_api():
    maybe(
        http_archive,
        name = "bazel_worker_api",
        sha256 = "5aac6ae6a23015cc7984492a114dc539effc244ec5ac7f8f6b1539c15fb376eb",
        urls = [
            "https://github.com/bazelbuild/bazel-worker-api/releases/download/v0.0.6/bazel-worker-api-v0.0.6.tar.gz",
        ],
        strip_prefix = "bazel-worker-api-0.0.6/proto",
    )
