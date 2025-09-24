load("@com_frobozz_rules_magic//magic:magic.bzl", "magic_library")

exports_files(
    [
        "private/magic.java.template",
        "private/test.sh.template",
    ],
    visibility = [":__pkg__"],
)

magic_library(
    name = "default-values",
)
