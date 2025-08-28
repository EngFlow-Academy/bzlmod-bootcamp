"""rules_magic public API"""

load(":magic_digests.bzl", _magic_digests = "magic_digests")
load(":magic_library.bzl", _magic_library = "magic_library")
load(":magic_test.bzl", _magic_test = "magic_test")
load(":deps.bzl", _rules_magic_deps = "rules_magic_deps")
load(":private/leaflet_repo.bzl", _magic_leaflet_repo = "magic_leaflet_repo")
load(
    "//toolchains:repositories.bzl",
    _rules_magic_spells_repositories = "rules_magic_spells_repositories",
)

magic_digests = _magic_digests
magic_library = _magic_library
magic_test = _magic_test
rules_magic_deps = _rules_magic_deps
rules_magic_spells_repositories = _rules_magic_spells_repositories

def rules_magic_leaflet_repo():
    _magic_leaflet_repo(name = "rules_magic_leaflet")

def rules_magic_toolchains():
    _rules_magic_spells_repositories()
    native.register_toolchains("//toolchains:all")
