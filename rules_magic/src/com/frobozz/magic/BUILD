load(
    "@com_google_protobuf//bazel:java_proto_library.bzl",
    "java_proto_library",
)
load("@rules_java//java:defs.bzl", "java_binary")

java_binary(
    name = "EmitDigestsWorker",
    srcs = [":EmitDigestsWorker.java"],
    deps = [":worker_protocol_java_proto"],
    visibility = ["//visibility:public"],
)

# Duplicated from @bazel_worker_java//:worker_protocol_java_proto to avoid:
# https://github.com/bazelbuild/bazel-worker-api/issues/7
java_proto_library(
    name = "worker_protocol_java_proto",
    deps = ["@bazel_worker_api//:worker_protocol_proto"],
)
