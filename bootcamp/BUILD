load(
    "@rules_magic//magic:magic.bzl",
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
    srcs = ["@rules_magic_leaflet"],
    outs = ["expansions.txt"],
    cmd = "\n".join([
        "echo {f}: $({f} @rules_magic_leaflet) >>$@".format(f = f)
        for f in ["execpath", "rootpath", "location"]
    ])
)

magic_digests(
    name = "hello",
    deps = [
        ":default-values",
        ":expansions",
        ":hello.txt",
        "@rules_magic_leaflet",
    ],
)

magic_test(
    name = "example_test",
    srcs = ["test.sh"],
    data = ["@rules_magic_leaflet"],
)
