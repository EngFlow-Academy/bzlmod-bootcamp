# Copyright 2025 EngFlow, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ---
#
# Modeled after:
# - https://github.com/bazel-contrib/rules_scala/blob/v7.1.4/scala_config.bzl

"""Generates the @com_frobozz_rules_magic_config repo."""

DEFAULT_MAGIC_VERSION = "1.2.3"
DEFAULT_GAME = "enchanter"

CONFIG_DEFAULTS = {
    "enable_some_feature": False,
    "game": DEFAULT_GAME,
    "games": [],
    "version": DEFAULT_MAGIC_VERSION,
    "versions": [],
}

CONFIG_ATTRS = {
    "enable_some_feature": attr.bool(
        default = CONFIG_DEFAULTS["enable_some_feature"],
        doc = (
            "Boolean to enable or disable some feature. " +
            "Overridden by the `ENABLE_SOME_FEATURE` environment variable."
        ),
    ),
    "game": attr.string(
        default = CONFIG_DEFAULTS["game"],
        doc = (
            "Game used for the default toolchain. " +
            "Overridden by the `MAGIC_GAME` environment variable."
        ),
    ),
    "games": attr.string_list(
        default = CONFIG_DEFAULTS["games"],
        doc = (
            "All games used to provide toolchains. " +
            "Must include the default game."
        ),
    ),
    "version": attr.string(
        default = CONFIG_DEFAULTS["version"],
        doc = (
            "Magic version used for the default toolchain. " +
            "Overridden by the `MAGIC_VERSION` environment variable."
        ),
    ),
    "versions": attr.string_list(
        default = CONFIG_DEFAULTS["versions"],
        doc = (
            "All magic versions used to provide toolchains. " +
            "Must include the default version."
        ),
    ),
}

CONFIG_ENVIRON = ["ENABLE_SOME_FEATURE", "MAGIC_GAME", "MAGIC_VERSION"]

_CONFIG_BUILD = """\
load("@bazel_skylib//rules:common_settings.bzl", "string_setting")

{settings}"""

_STRING_SETTING_TEMPLATE = """\
string_setting(
    name = "{name}",
    build_setting_default = "{default}",
    values = {values},
    visibility = ["//visibility:public"],
)
"""

_CONFIG_SETTING_TEMPLATE = """\
config_setting(
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
            default = game,
            values = games,
        ),
    ]))

def _config_file_content(
        version,
        versions,
        game,
        games,
        enable_some_feature):
    return "\n".join([
        "MAGIC_VERSION = \"" + version + "\"",
        "MAGIC_VERSIONS = " + str(versions),
        "GAME = \"" + game + "\"",
        "GAMES = " + str(games),
        "ENABLE_SOME_FEATURE = " + enable_some_feature,
    ]) + "\n"

def _get_options_and_validate_default(
        rctx,
        env_var,
        default_name,
        options_name):
    default = rctx.os.environ.get(env_var, getattr(rctx.attr, default_name))
    options = getattr(rctx.attr, options_name)

    if not options:
        options = [default]
    elif default not in options:
        fail("You have to include the default %s (%s) in the `%s` list." % (
            default_name,
            default,
            options_name,
        ))
    return default, options

def _store_config(repository_ctx):
    version, versions = _get_options_and_validate_default(
        repository_ctx,
        "MAGIC_VERSION",
        "version",
        "versions",
    )
    game, games = _get_options_and_validate_default(
        repository_ctx,
        "MAGIC_GAME",
        "game",
        "games",
    )
    enable_some_feature = repository_ctx.os.environ.get(
        "ENABLE_SOME_FEATURE",
        str(repository_ctx.attr.enable_some_feature),
    )
    repository_ctx.file(
        "BUILD",
        _build_file_content(version, versions, game, games),
    )
    repository_ctx.file(
        "config.bzl",
        _config_file_content(
            version,
            versions,
            game,
            games,
            enable_some_feature,
        ),
    )

_config_repository = repository_rule(
    implementation = _store_config,
    doc = "rules_magic configuration parameters",
    attrs = CONFIG_ATTRS,
    environ = CONFIG_ENVIRON,
)

def magic_config(
        version = DEFAULT_MAGIC_VERSION,
        versions = [],
        game = DEFAULT_GAME,
        games = [],
        enable_some_feature = False):
    _config_repository(
        name = "com_frobozz_rules_magic_config",
        version = version,
        versions = versions,
        game = game,
        games = games,
        enable_some_feature = enable_some_feature,
    )
