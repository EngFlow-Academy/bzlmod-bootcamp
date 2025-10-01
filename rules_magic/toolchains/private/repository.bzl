"""Macros for configuring and instantiating toolchains."""

_BUILD_FILE = """\
load(
    "@@{rules_magic_repo}//toolchains:toolchains.bzl",
    "setup_magic_toolchain",
)

GAMES = [
{games}
]

setup_magic_toolchain(name = "default_settings_toolchain")

[
    setup_magic_toolchain(
        name = game + "_toolchain",
        game = game,
    )
    for game in GAMES
]
"""

_RULES_MAGIC_REPO_NAME = Label("//:all").repo_name

def _rules_magic_spells_toolchains_impl(rctx):
    # Generate a root package so that the `register_toolchains` call in
    # `MODULE.bazel` always succeeds.
    rctx.file("BUILD", executable = False)

    # In this case, we could eliminate the duplication by iterating over
    # `KNOWN_GAMES` from `repositories.bzl`. In general, the toolchain package
    # instantiation logic and format may be quite different.
    games = {}
    default_game = rctx.attr.default_game

    if rctx.attr.enchanter:
        games["enchanter"] = "    \"enchanter\","
    if rctx.attr.sorcerer:
        games["sorcerer"] = "    \"sorcerer\","
    if rctx.attr.spellbreaker:
        games["spellbreaker"] = "    \"spellbreaker\","

    if len(games) == 0:
        return

    if default_game not in games:
        fail("default game \"%s\" not in: %s" % (
            default_game,
            ", ".join(games.keys()),
        ))

    rctx.file(
        "spells/BUILD",
        content = _BUILD_FILE.format(
            default = default_game,
            games = "\n".join(games.values()),
            rules_magic_repo = _RULES_MAGIC_REPO_NAME,
        ),
        executable = False,
    )

rules_magic_spells_toolchains = repository_rule(
    implementation = _rules_magic_spells_toolchains_impl,
    attrs = {
        "default_game": attr.string(mandatory = True),
        "enchanter": attr.bool(),
        "sorcerer": attr.bool(),
        "spellbreaker": attr.bool(),
    },
)
