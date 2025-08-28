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

"""Macro for instantiating builtin toolchain dependency repos."""

load(":magic_spells_repository.bzl", "magic_spells_repository")

BUILTIN_GAMES = ["enchanter", "sorcerer", "spellbreaker"]

def setup_magic_spells_repositories(name = None):
    """Instantiates a `magic_spells_repository` for all builtin games.

    Also binds each repository to `//external:{game}_spells` targets, where
    `{game}` is the name of each builtin game.

    Args:
        name: unused; defined to satisfy buildifier
    """
    for game in BUILTIN_GAMES:
        repo_name = "rules_magic_spells_" + game

        # Typically a dependency macro will contain a series of `http_archive`
        # calls. We use a custom repo rule to keep the example self-contained.
        magic_spells_repository(
            name = repo_name,
            spells_json = Label("//magic:private/spells/%s.json" % game),
        )

        native.bind(
            name = game + "_spells",
            actual = "@%s" % repo_name,
        )
