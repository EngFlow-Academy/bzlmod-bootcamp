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

def rules_magic_spells_repositories(new_local_repository = None):
    if new_local_repository == None:
        new_local_repository = native.new_local_repository

    for game in KNOWN_GAMES:
        repo_name = "rules_magic_spells_" + game

        # This stands in for a remote http_archive.
        new_local_repository(
            name = repo_name,
            path = "../spells/" + game,
            build_file_content = _BUILD_FILE.format(repo_name = repo_name),
        )
