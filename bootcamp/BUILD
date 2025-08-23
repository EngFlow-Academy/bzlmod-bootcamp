load(
    "@io_frobozzco_rules_bootcamp//bootcamp:bootcamp.bzl",
    "bootcamp_digests",
    "bootcamp_library",
)

bootcamp_library(
    name = "default-values",
)

bootcamp_digests(
    name = "hello",
    deps = [
        ":default-values",
        ":hello.txt",
    ],
)
