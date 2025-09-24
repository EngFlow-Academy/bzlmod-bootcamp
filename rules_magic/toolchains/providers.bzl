"""Toolchain provider definitions

See: https://bazel.build/extending/rules#providers
"""

MagicInfo = provider(
    "Configured values for the rules_magic toolchain",
    fields = {
        "version": "string identifying the rules_magic version",
        "versions": "strings identifying all valid rules_magic versions",
        "game": "string identifying the game providing these spells",
        "games": "strings identifying all configured games",
        "some_feature": "boolean indicating enablement of some_feature",
        "spells_json": "path to JSON file describing spells from this game",
    },
)
