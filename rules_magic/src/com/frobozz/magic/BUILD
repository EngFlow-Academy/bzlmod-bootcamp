load("@rules_java//java:defs.bzl", "java_binary")

java_binary(
    name = "EmitDigestsWorker",
    srcs = [":EmitDigestsWorker.java"],
    deps = ["@bazel_tools//src/main/protobuf:worker_protocol_java_proto"],
    visibility = ["//visibility:public"],
)
