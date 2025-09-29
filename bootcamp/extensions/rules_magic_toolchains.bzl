"""Module extension for rules_magic toolchains."""

load("@rules_magic//magic:magic.bzl", "rules_magic_toolchains")

def _magic_toolchains_impl(_):
    rules_magic_toolchains()

magic_toolchains = module_extension(
    implementation = _magic_toolchains_impl,
)
