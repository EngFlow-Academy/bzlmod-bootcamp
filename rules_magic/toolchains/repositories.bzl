"""Macros for configuring and instantiating toolchains."""

KNOWN_GAMES = ["enchanter", "sorcerer", "spellbreaker"]

def rules_magic_spells_repositories():
    for game in KNOWN_GAMES:
        # This stands in for a remote http_archive.
        native.local_repository(
            name = "rules_magic_spells_" + game,
            path = "../spells/" + game,
        )

        native.bind(
            name = game + "_spells",
            actual = "@rules_magic_spells_%s//:spells.json" % game,
        )
