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

"""Macro for setting up a rules_magic toolchain."""

load(
    "@com_frobozz_rules_magic//magic:magic_toolchain.bzl",
    "magic_toolchain",
)
load(
    "@com_frobozz_rules_magic//magic:private/setup_magic_spells_repositories.bzl",
    "BUILTIN_GAMES",
)
load(
    "@com_frobozz_rules_magic_config//:config.bzl",
    "ENABLE_SOME_FEATURE",
    "GAME",
    "MAGIC_VERSION",
)

def setup_magic_toolchain(
        name,
        magic_version = MAGIC_VERSION,
        game = GAME,
        spells_json = None,
        some_feature = ENABLE_SOME_FEATURE):
    if spells_json == None and game in BUILTIN_GAMES:
        spells_json = "//external:%s_spells" % game

    magic_toolchain(
        name = name + "_impl",
        magic_version = magic_version,
        game = game,
        spells_json = spells_json,
        some_feature = some_feature,
    )

    native.toolchain(
        name = name,
        toolchain = ":" + name + "_impl",
        toolchain_type = "@com_frobozz_rules_magic//magic:toolchain_type",
    )
