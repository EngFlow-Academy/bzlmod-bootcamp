def _bootcamp_toolchain_impl(ctx):
    return platform_common.ToolchainInfo(
    )

bootcamp_toolchain = rule(
    implementation = _bootcamp_toolchain_impl,
    attrs = {
    },
)
