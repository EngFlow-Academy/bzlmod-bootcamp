"""rules_magic public API"""

load(
    "@com_frobozz_rules_magic//magic:magic_digests.bzl",
    _magic_digests = "magic_digests",
)
load(
    "@com_frobozz_rules_magic//magic:magic_library.bzl",
    _magic_library = "magic_library",
)
load(
    "@com_frobozz_rules_magic//magic:magic_test.bzl",
    _magic_test = "magic_test",
)
load(
    "@com_frobozz_rules_magic//magic:deps.bzl",
    _rules_magic_deps = "rules_magic_deps",
)
load(
    "@com_frobozz_rules_magic//magic:private/leaflet_repo.bzl",
    _magic_leaflet_repo = "magic_leaflet_repo",
)
load(
    "@com_frobozz_rules_magic//magic:toolchains.bzl",
    _rules_magic_toolchains = "rules_magic_toolchains",
)
magic_digests = _magic_digests
magic_library = _magic_library
magic_test = _magic_test
rules_magic_deps = _rules_magic_deps
rules_magic_toolchains = _rules_magic_toolchains

def rules_magic_leaflet_repo():
    _magic_leaflet_repo(name = "com_frobozz_rules_magic_leaflet")
