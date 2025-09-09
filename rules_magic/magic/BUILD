load("@com_frobozz_rules_magic//magic:magic.bzl", "magic_library")
load("@com_frobozz_rules_magic//magic:magic_toolchain.bzl", "magic_toolchain")

exports_files(
    ["private/magic.java.template"],
    visibility = [":__pkg__"],
)

toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

magic_toolchain(
    name = "default_settings",
)

toolchain(
    name = "default_settings_toolchain",
    toolchain = ":default_settings",
    toolchain_type = ":toolchain_type",
)

magic_library(
    name = "default-values",
)
