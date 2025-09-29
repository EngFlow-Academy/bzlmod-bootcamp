"""Module extension to generate the @rules_magic_leaflet_repo repo."""

load("@rules_magic//magic:magic.bzl", "rules_magic_leaflet_repo")

def _magic_leaflet_impl(mctx):
    rules_magic_leaflet_repo()

magic_leaflet = module_extension(
    implementation = _magic_leaflet_impl,
)
