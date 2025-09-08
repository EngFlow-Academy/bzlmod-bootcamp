load(
    "@io_frobozzco_rules_bootcamp//bootcamp:bootcamp.bzl",
    "bootcamp_digests",
    "bootcamp_library",
    "bootcamp_test",
)

bootcamp_library(
    name = "default-values",
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
        "@io_frobozzco_rules_bootcamp_leaflet",
    ],
)

bootcamp_test(
    name = "example_test",
    srcs = ["test.sh"],
    deps = ["@io_frobozzco_rules_bootcamp_leaflet"],
    data = ["$(location @io_frobozzco_rules_bootcamp_leaflet)"],
)
