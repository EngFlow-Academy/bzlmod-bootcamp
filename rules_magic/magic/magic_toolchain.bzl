"""https://bazel.build/extending/toolchains"""

load("@com_frobozz_rules_magic//magic:providers.bzl", "MagicInfo")
load(
    "@com_frobozz_rules_magic_config//:config.bzl",
    "MAGIC_VERSION",
    "MAGIC_VERSIONS",
    "ENABLE_SOME_FEATURE",
)

_ATTRS = {
    "version": attr.string(default = MAGIC_VERSION),
    "some_feature": attr.bool(default = ENABLE_SOME_FEATURE),
}

def _magic_toolchain_impl(ctx):
    return [
        platform_common.ToolchainInfo(
            magic_info = MagicInfo(
                version = ctx.attr.version,
                versions = MAGIC_VERSIONS,
                some_feature = ctx.attr.some_feature,
            )
        ),
    ]

magic_toolchain = rule(
    implementation = _magic_toolchain_impl,
    attrs = _ATTRS,
)
