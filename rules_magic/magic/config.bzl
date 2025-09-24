"""Generates the @com_frobozz_rules_magic_config repo.

Modeled after @rules_scala//scala_config.bzl.
"""

DEFAULT_MAGIC_VERSION = "1.2.3"
DEFAULT_GAME = "enchanter"

_CONFIG_BUILD = (
"""load("@bazel_skylib//rules:common_settings.bzl", "string_setting")

{settings}""")

_STRING_SETTING_TEMPLATE = """string_setting(
    name = "{name}",
    build_setting_default = "{default}",
    values = {values},
    visibility = ["//visibility:public"],
)
"""

_CONFIG_SETTING_TEMPLATE = """config_setting(
    name = "{name}_{suffix}",
    flag_values = {{":{name}": "{value}"}},
    visibility = ["//visibility:public"],
)
"""

def _generate_settings(name, default, values):
    return "\n".join([
        _STRING_SETTING_TEMPLATE.format(
            name = name,
            default = default,
            values = values,
        ),
    ] + [
        _CONFIG_SETTING_TEMPLATE.format(
            name = name,
            suffix = value.replace(".", "_"),
            value = value,
        )
        for value in values
    ])

def _build_file_content(magic_version, magic_versions, game, games):
    return _CONFIG_BUILD.format(settings = "\n".join([
        _generate_settings(
            name = "magic_version",
            default = magic_version,
            values = magic_versions,
        ),
        _generate_settings(
            name = "game",
            default = DEFAULT_GAME,
            values = games,
        ),
    ]))

def _config_file_content(
    magic_version,
    magic_versions,
    game,
    games,
    enable_some_feature):
    return "\n".join([
        "MAGIC_VERSION = \"" + magic_version + "\"",
        "MAGIC_VERSIONS = " + str(magic_versions),
        "GAME = \"" + game + "\"",
        "GAMES = " + str(games),
        "ENABLE_SOME_FEATURE = " + enable_some_feature,
    ]) + "\n"

def _get_options_and_validate_default(desc, options_name, default, options):
    if not options:
        options = [default]
    elif default not in options:
        fail("You have to include the default %s (%s) in the `%s` list." % (
            desc,
            default,
            options_name,
        ))
    return default, options

def _store_config(repository_ctx):
    rctx_env = repository_ctx.os.environ
    rctx_attr = repository_ctx.attr

    # Default parameters
    magic_version, magic_versions = _get_options_and_validate_default(
        "magic version",
        "magic_versions",
        rctx_env.get("MAGIC_VERSION", rctx_attr.magic_version),
        rctx_attr.magic_versions,
    )
    game, games = _get_options_and_validate_default(
        "game",
        "games",
        rctx_env.get("MAGIC_GAME", rctx_attr.game),
        rctx_attr.games,
    )
    enable_some_feature = rctx_env.get(
        "ENABLE_SOME_FEATURE",
        str(rctx_attr.enable_some_feature),
    )

    repository_ctx.file(
        "BUILD",
        _build_file_content(magic_version, magic_versions, game, games),
    )
    repository_ctx.file(
        "config.bzl",
        _config_file_content(
            magic_version,
            magic_versions,
            game,
            games,
            enable_some_feature,
        ),
    )

_config_repository = repository_rule(
    implementation = _store_config,
    doc = "rules_magic configuration parameters",
    attrs = {
        "magic_version": attr.string(
            mandatory = True,
            doc = "Default magic version",
        ),
        "magic_versions": attr.string_list(
            mandatory = True,
            doc = (
                "List of all magic versions to configure. " +
                "Must include the default version."
            ),
        ),
        "game": attr.string(
            mandatory = True,
            doc = "Default game containing spells to use",
        ),
        "games": attr.string_list(
            mandatory = True,
            doc = (
                "List of all games to configure. " +
                "Must include the default game."
            ),
        ),
        "enable_some_feature": attr.bool(
            default = False,
            doc = "Boolean to enable or disable some feature",
        ),
    },
    environ = ["MAGIC_VERSION", "MAGIC_GAME", "ENABLE_SOME_FEATURE"],
)

def magic_config(
        version = DEFAULT_MAGIC_VERSION,
        versions = [],
        game = DEFAULT_GAME,
        games = [],
        enable_some_feature = False):
    _config_repository(
        name = "com_frobozz_rules_magic_config",
        magic_version = version,
        magic_versions = versions,
        game = game,
        games = games,
        enable_some_feature = enable_some_feature,
    )
