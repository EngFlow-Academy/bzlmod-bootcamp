"""https://bazel.build/extending/toolchains"""

load("@io_frobozzco_rules_bootcamp//bootcamp:providers.bzl", "BootcampInfo")
load(
    "@io_frobozzco_rules_bootcamp_config//:config.bzl",
    "BOOTCAMP_VERSION",
    "BOOTCAMP_VERSIONS",
    "ENABLE_SOME_FEATURE",
)

_ATTRS = {
    "version": attr.string(default = BOOTCAMP_VERSION),
    "some_feature": attr.bool(default = ENABLE_SOME_FEATURE),
}

def _bootcamp_toolchain_impl(ctx):
    return [
        platform_common.ToolchainInfo(
            bootcamp_info = BootcampInfo(
                version = ctx.attr.version,
                versions = BOOTCAMP_VERSIONS,
                some_feature = ctx.attr.some_feature,
            )
        ),
    ]

bootcamp_toolchain = rule(
    implementation = _bootcamp_toolchain_impl,
    attrs = _ATTRS,
)
