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

load("@com_frobozz_rules_magic//magic:magic.bzl",
    "magic_library",
    "setup_magic_toolchain",
)
load(
    "@com_frobozz_rules_magic//magic:private/setup_magic_spells_repositories.bzl",
    "BUILTIN_GAMES",
)

exports_files(
    [
        "private/magic.java.template",
        "private/test.sh.template",
    ],
    visibility = [":__pkg__"],
)

magic_library(
    name = "default-values",
)

# Toolchains of this type must return a `ToolchainInfo` object with the
# `MagicInfo` provider from `magic_info.bzl`:
#
#   ToolchainInfo(
#       magic_info = MagicInfo(...),
#   )
toolchain_type(name = "toolchain_type")

setup_magic_toolchain(name = "default_settings_toolchain")

[
    setup_magic_toolchain(
        name = game + "_toolchain",
        game = game,
    )
    for game in BUILTIN_GAMES
]
