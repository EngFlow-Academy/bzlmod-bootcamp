"""Macro to instantiate @rules_magic_toolchains"""

load("//toolchains:repositories.bzl", "rules_magic_spells_repository")
load("//toolchains:private/repository.bzl", "rules_magic_spells_toolchains")
load("@rules_magic_config//:config.bzl", "GAME")

DEFAULT_TOOLCHAINS_REPO_NAME = "rules_magic_toolchains"

def magic_toolchains(
    name = DEFAULT_TOOLCHAINS_REPO_NAME,
    enchanter = False,
    sorcerer = False,
    spellbreaker = False,
    default_game = GAME,
    new_local_repository = None):
    if new_local_repository == None:
        new_local_repository = native.new_local_repository

    # In this case, we could eliminate the duplication by iterating over
    # `KNOWN_GAMES` from `repositories.bzl`. In general, the toolchain repo
    # instantiation logic may be quite different.
    if enchanter:
        rules_magic_spells_repository("enchanter", new_local_repository)
    if sorcerer:
        rules_magic_spells_repository("sorcerer", new_local_repository)
    if spellbreaker:
        rules_magic_spells_repository("spellbreaker", new_local_repository)

    rules_magic_spells_toolchains(
        name = DEFAULT_TOOLCHAINS_REPO_NAME,
        default_game = default_game,
        enchanter = enchanter,
        sorcerer = sorcerer,
        spellbreaker = spellbreaker,
    )

def rules_magic_register_toolchains(name = DEFAULT_TOOLCHAINS_REPO_NAME):
    """Legacy WORKSPACE only."""
    native.register_toolchains("@%s//...:all" % name)
