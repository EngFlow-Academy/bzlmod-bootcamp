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

def rules_magic_spells_repositories():
    for game in KNOWN_GAMES:
        repo_name = "rules_magic_spells_" + game

        # This stands in for a remote http_archive.
        native.new_local_repository(
            name = repo_name,
            path = "../spells/" + game,
            build_file_content = _BUILD_FILE.format(repo_name = repo_name),
        )

        native.bind(
            name = game + "_spells",
            actual = "@%s" % repo_name,
        )
