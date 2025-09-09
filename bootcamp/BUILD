load(
    "@com_frobozz_rules_magic//magic:magic.bzl",
    "magic_digests",
    "magic_library",
    "magic_test",
)

magic_library(
    name = "default-values",
)

# Just a copy, but demonstrates the Bazel 8 `$(location)` problem from:
# - https://github.com/bazelbuild/bazel/issues/25198
# - https://github.com/mbland/bazel-8-location
genrule(
    name = "leaflet",
    srcs = ["@com_frobozz_rules_magic_leaflet"],
    outs = ["leaflet.txt"],
    cmd = "cp $(location @com_frobozz_rules_magic_leaflet) $@",
)

genrule(
    name = "expansions",
    srcs = ["@com_frobozz_rules_magic_leaflet"],
    outs = ["expansions.txt"],
    cmd = "\n".join([
        "echo {f}: $({f} @com_frobozz_rules_magic_leaflet) >>$@".format(f = f)
        for f in ["execpath", "rootpath", "location"]
    ])
)

magic_digests(
    name = "hello",
    deps = [
        ":default-values",
        ":expansions",
        ":hello.txt",
        ":leaflet",
        "@com_frobozz_rules_magic_leaflet",
    ],
)

magic_test(
    name = "example_test",
    srcs = ["test.sh"],
    deps = ["@com_frobozz_rules_magic_leaflet"],
    data = ["$(location @com_frobozz_rules_magic_leaflet)"],
)
