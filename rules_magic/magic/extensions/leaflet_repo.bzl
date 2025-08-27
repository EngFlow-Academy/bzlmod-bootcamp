"""Module extension to generate the @rules_magic_leaflet_repo repo."""

load("//magic:leaflet_repo.bzl", "rules_magic_leaflet_repo")

def _magic_leaflet_impl(mctx):
    rules_magic_leaflet_repo()

magic_leaflet = module_extension(
    implementation = _magic_leaflet_impl,
)
