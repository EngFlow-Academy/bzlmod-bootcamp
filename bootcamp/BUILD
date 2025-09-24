load(
    "@com_frobozz_rules_magic//magic:magic.bzl",
    "magic_digests",
    "magic_library",
    "magic_test",
)

load("@rules_java//java:defs.bzl", "java_binary")

magic_library(
    name = "default-values",
)

java_binary(
    name = "EmitValues",
    main_class = "bootcamp.EmitValues",
    srcs = ["EmitValues.java"],
    deps = [":default-values"],
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
        "@com_frobozz_rules_magic_leaflet",
    ],
)

magic_test(
    name = "example_test",
    srcs = ["test.sh"],
    deps = ["@com_frobozz_rules_magic_leaflet"],
    data = ["$(location @com_frobozz_rules_magic_leaflet)"],
)
