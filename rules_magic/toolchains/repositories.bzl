"""Macros for configuring and instantiating toolchains."""

KNOWN_GAMES = ["enchanter", "sorcerer", "spellbreaker"]

_BUILD_FILE = """\
exports_files(["spells.json"])

alias(
    name = "{repo_name}",
    actual = ":spells.json",
    visibility = ["//visibility:public"],
)
"""

def rules_magic_spells_repository(name, new_local_repository):
    """Instantiate a spells repository for a specific game."""
    if name not in KNOWN_GAMES:
        fail("unknown game '{game}'; known games are: {known_games}".format(
            game = name,
            known_games = ", ".join(KNOWN_GAMES),
        ))

    repo_name = "rules_magic_spells_" + name

    # This stands in for a remote http_archive.
    new_local_repository(
        name = repo_name,
        path = "../spells/" + name,
        build_file_content = _BUILD_FILE.format(repo_name = repo_name),
    )
