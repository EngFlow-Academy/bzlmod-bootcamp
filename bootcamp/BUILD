load(
    "@io_frobozzco_rules_bootcamp//bootcamp:bootcamp.bzl",
    "bootcamp_digests",
    "bootcamp_library",
    "bootcamp_test",
)

bootcamp_library(
    name = "default-values",
)

# Just a copy, but demonstrates the Bazel 8 `$(location)` problem from:
# - https://github.com/bazelbuild/bazel/issues/25198
# - https://github.com/mbland/bazel-8-location
genrule(
    name = "leaflet",
    srcs = ["@io_frobozzco_rules_bootcamp_leaflet"],
    outs = ["leaflet.txt"],
    cmd = "cp $(location @io_frobozzco_rules_bootcamp_leaflet) $@",
)

genrule(
    name = "expansions",
    srcs = ["@io_frobozzco_rules_bootcamp_leaflet"],
    outs = ["expansions.txt"],
    cmd = "\n".join([
        "echo {f}: $({f} @io_frobozzco_rules_bootcamp_leaflet) >>$@".format(f = f)
        for f in ["execpath", "rootpath", "location"]
    ])
)

bootcamp_digests(
    name = "hello",
    deps = [
        ":default-values",
        ":expansions",
        ":hello.txt",
        ":leaflet",
        "@io_frobozzco_rules_bootcamp_leaflet",
    ],
)

bootcamp_test(
    name = "example_test",
    srcs = ["test.sh"],
    deps = ["@io_frobozzco_rules_bootcamp_leaflet"],
    data = ["$(location @io_frobozzco_rules_bootcamp_leaflet)"],
)
