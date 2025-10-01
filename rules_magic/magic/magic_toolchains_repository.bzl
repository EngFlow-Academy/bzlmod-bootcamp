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

"""Macros for configuring and instantiating toolchains."""

# buildifier: disable=canonical-repository
_BUILD_FILE = """\
load(
    "@@{rules_magic_repo}//magic:magic.bzl",
    "setup_magic_toolchain",
)

GAMES_TO_SPELLS_REPO = {{
{games}
}}

toolchain(
    name = "00_default_settings_toolchain",
    toolchain = ":{default_game}_toolchain_impl",
    toolchain_type = "@@{rules_magic_repo}//magic:toolchain_type",
)

[
    setup_magic_toolchain(
        name = game + "_toolchain",
        game = game,
        spells_json = spells_repo,
    )
    for game, spells_repo in GAMES_TO_SPELLS_REPO.items()
]
"""

_RULES_MAGIC_REPO_NAME = Label("//:all").repo_name

def _magic_toolchains_repository_impl(rctx):
    # Generate a root package so that the `register_toolchains` call in
    # `MODULE.bazel` always succeeds.
    rctx.file("BUILD", executable = False)

    games_entries = []
    default_game = rctx.attr.default_game
    games_to_spells_repo = rctx.attr.games_to_spells_repo

    if default_game not in games_to_spells_repo:
        fail("default game \"%s\" not in: %s" % (
            default_game,
            ", ".join(games_to_spells_repo.keys()),
        ))

    for game, spells_repo in games_to_spells_repo.items():
        games_entries.append("    \"%s\": \"%s\"," % (game, spells_repo))

    rctx.file(
        "spells/BUILD",
        content = _BUILD_FILE.format(
            default_game = default_game,
            games = "\n".join(games_entries),
            rules_magic_repo = _RULES_MAGIC_REPO_NAME,
        ),
        executable = False,
    )

magic_toolchains_repository = repository_rule(
    implementation = _magic_toolchains_repository_impl,
    attrs = {
        "default_game": attr.string(mandatory = True),
        # `attr.string_keyed_label_dict` isn't available in Bazel 6.
        "games_to_spells_repo": attr.string_dict(),
    },
)
