"""https://bazel.build/extending/toolchains"""

load(":providers.bzl", "MagicInfo")
load(":repositories.bzl", "KNOWN_GAMES")
load(
    "@rules_magic_config//:config.bzl",
    "ENABLE_SOME_FEATURE",
    "GAME",
    "GAMES",
    "MAGIC_VERSION",
    "MAGIC_VERSIONS",
)

_ATTRS = {
    "magic_version": attr.string(default = MAGIC_VERSION),
    "game": attr.string(default = GAME),
    "spells_json": attr.label(
        allow_single_file = True,
        mandatory = True,
    ),
    "some_feature": attr.bool(default = ENABLE_SOME_FEATURE),
}

def _magic_toolchain_impl(ctx):
    return [
        platform_common.ToolchainInfo(
            magic_info = MagicInfo(
                version = ctx.attr.magic_version,
                versions = MAGIC_VERSIONS,
                game = ctx.attr.game,
                games = GAMES,
                some_feature = ctx.attr.some_feature,
                spells_json = ctx.attr.spells_json,
            )
        ),
    ]

magic_toolchain = rule(
    implementation = _magic_toolchain_impl,
    attrs = _ATTRS,
)

def setup_magic_toolchain(
    name,
    magic_version = MAGIC_VERSION,
    game = GAME,
    some_feature = ENABLE_SOME_FEATURE):

    if game not in KNOWN_GAMES:
        fail("unknown game \"%s\"; options are: %s" % (game, KNOWN_GAMES))

    magic_toolchain(
        name = name + "_impl",
        magic_version = magic_version,
        game = game,
        spells_json = "//external:%s_spells" % game,
        some_feature = some_feature,
    )

    native.toolchain(
        name = name,
        toolchain = ":" + name + "_impl",
        toolchain_type = "//toolchains:toolchain_type",
    )
