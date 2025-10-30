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

"""Rule for defining a rules_magic toolchain implementation.

See: https://bazel.build/extending/toolchains
"""

load("@com_frobozz_rules_magic//magic:magic_info.bzl", "MagicInfo")
load(
    "@com_frobozz_rules_magic_config//:config.bzl",
    "ENABLE_SOME_FEATURE",
    "GAME",
    "GAMES",
    "MAGIC_VERSION",
    "MAGIC_VERSIONS",
)

_ATTRS = {
    "game": attr.string(default = GAME),
    "magic_version": attr.string(default = MAGIC_VERSION),
    "some_feature": attr.bool(default = ENABLE_SOME_FEATURE),
    "spells_json": attr.label(
        allow_single_file = [".json"],
        mandatory = True,
    ),
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
            ),
        ),
    ]

magic_toolchain = rule(
    implementation = _magic_toolchain_impl,
    attrs = _ATTRS,
)
