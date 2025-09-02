"""rules_bootcamp public API"""

load(
    "@io_frobozzco_rules_bootcamp//bootcamp:bootcamp_digests.bzl",
    _bootcamp_digests = "bootcamp_digests",
)
load(
    "@io_frobozzco_rules_bootcamp//bootcamp:bootcamp_library.bzl",
    _bootcamp_library = "bootcamp_library",
)
load(
    "@io_frobozzco_rules_bootcamp//bootcamp:deps.bzl",
    _rules_bootcamp_deps = "rules_bootcamp_deps",
)
load(
    "@io_frobozzco_rules_bootcamp//bootcamp:private/leaflet_repo.bzl",
    _bootcamp_leaflet_repo = "bootcamp_leaflet_repo",
)
load(
    "@io_frobozzco_rules_bootcamp//bootcamp:toolchains.bzl",
    _rules_bootcamp_toolchains = "rules_bootcamp_toolchains",
)
bootcamp_digests = _bootcamp_digests
bootcamp_library = _bootcamp_library
rules_bootcamp_deps = _rules_bootcamp_deps
rules_bootcamp_toolchains = _rules_bootcamp_toolchains

def rules_bootcamp_leaflet_repo():
    _bootcamp_leaflet_repo(name = "io_frobozzco_rules_bootcamp_leaflet")
