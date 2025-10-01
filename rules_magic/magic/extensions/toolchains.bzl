"""Module extension for rules_magic toolchains."""

load("//magic/extensions:private/bzlmod.bzl", "root_module_settings")
load("//magic:magic_toolchains.bzl", _magic_toolchains = "magic_toolchains")
load("@rules_magic_config//:config.bzl", "GAME")
load("@bazel_tools//tools/build_defs/repo:local.bzl", "new_local_repository")

# These match the `_magic_toolchains` arguments, which match the
# attributes of `rules_magic_spells_toolchains` from
# `//toolchains:private/repository.bzl`.
_settings_defaults = {
    "default_game": GAME,
    "enchanter": False,
    "sorcerer": False,
    "spellbreaker": False,
}

_settings_attrs = {
    "default_game": attr.string(
        default = _settings_defaults["default_game"],
    ),
    "enchanter": attr.bool(
        default = _settings_defaults["enchanter"],
    ),
    "sorcerer": attr.bool(
        default = _settings_defaults["sorcerer"],
    ),
    "spellbreaker": attr.bool(
        default = _settings_defaults["spellbreaker"],
    ),
}

_tag_classes = {
    "settings": tag_class(
        attrs = _settings_attrs,
        doc = "`rules_magic` configuration parameters",
    ),
}

def _magic_toolchains_impl(module_ctx):
    _magic_toolchains(
        new_local_repository = new_local_repository,
        **root_module_settings(module_ctx, _settings_defaults)
    )

magic_toolchains = module_extension(
    implementation = _magic_toolchains_impl,
    tag_classes = _tag_classes,
)
