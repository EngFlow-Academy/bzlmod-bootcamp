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

"""Module extension for rules_magic toolchains."""

load("@rules_magic_config//:config.bzl", "GAME")
load("//magic:toolchains.bzl", _magic_toolchains = "magic_toolchains")
load(":private/bzlmod.bzl", "root_module_settings")

# These match the `magic_toolchains` arguments.
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
        **root_module_settings(module_ctx, _settings_defaults)
    )
    return module_ctx.extension_metadata(reproducible = True)

magic_toolchains = module_extension(
    implementation = _magic_toolchains_impl,
    tag_classes = _tag_classes,
)
