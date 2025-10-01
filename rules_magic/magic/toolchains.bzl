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

"""Macro to instantiate @rules_magic_toolchains"""

load("@rules_magic_config//:config.bzl", "GAME")
load(":magic_spells_repository.bzl", "magic_spells_repository")
load(":magic_toolchains_repository.bzl", "magic_toolchains_repository")

DEFAULT_TOOLCHAINS_REPO_NAME = "rules_magic_toolchains"

def magic_toolchains(
        name = DEFAULT_TOOLCHAINS_REPO_NAME,
        enchanter = False,
        sorcerer = False,
        spellbreaker = False,
        default_game = GAME):
    """Configure and instantiate the toolchains repo and its dependency repos.

    Args:
        name: name of the toolchain repo containing the configured toolchains
        enchanter: enable the Enchanter game's toolchain
        sorcerer: enable the Sorcerer game's toolchain
        spellbreaker: enable the Spellbreaker game's toolchain
        default_game: determines which game's toolchain is the default
    """
    games = []

    if enchanter:
        games.append("enchanter")
    if sorcerer:
        games.append("sorcerer")
    if spellbreaker:
        games.append("spellbreaker")

    for game in games:
        magic_spells_repository(
            name = "rules_magic_spells_" + game,
            spells_json = Label("//magic:private/spells/%s.json" % game),
        )

    magic_toolchains_repository(
        name = DEFAULT_TOOLCHAINS_REPO_NAME,
        default_game = default_game,
        games_to_spells_repo = {
            game: "@rules_magic_spells_" + game
            for game in games
        },
    )

def rules_magic_register_toolchains(name = DEFAULT_TOOLCHAINS_REPO_NAME):
    """Registers all toolchains in the rules_magic toolchains repository.

    For legacy WORKSPACE builds only. For Bzlmod, use
    //magic/extensions:toolchains.bzl.

    Args:
        name: the repository containing toolchains to register
    """
    native.register_toolchains("@%s//...:all" % name)
