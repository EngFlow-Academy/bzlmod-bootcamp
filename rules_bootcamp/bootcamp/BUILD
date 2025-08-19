load(
    "@io_frobozzco_rules_bootcamp//bootcamp:bootcamp.bzl",
    "bootcamp_toolchain",
)

exports_files(
    ["private/bootcamp.java.template"],
    visibility = [":__pkg__"],
)

toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

bootcamp_toolchain(
    name = "default_settings",
)

toolchain(
    name = "default_settings_toolchain",
    toolchain = ":default_settings",
    toolchain_type = ":toolchain_type",
)
