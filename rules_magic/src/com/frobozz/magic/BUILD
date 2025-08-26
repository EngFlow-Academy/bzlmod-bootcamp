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

load(
    "@com_google_protobuf//bazel:java_proto_library.bzl",
    "java_proto_library",
)
load("@rules_java//java:defs.bzl", "java_binary")

java_binary(
    name = "EmitDigestsWorker",
    srcs = [":EmitDigestsWorker.java"],
    visibility = ["//visibility:public"],
    deps = [":worker_protocol_java_proto"],
)

# Duplicated from @bazel_worker_java//:worker_protocol_java_proto to avoid:
# https://github.com/bazelbuild/bazel-worker-api/issues/7
java_proto_library(
    name = "worker_protocol_java_proto",
    deps = ["@bazel_worker_api//:worker_protocol_proto"],
)
