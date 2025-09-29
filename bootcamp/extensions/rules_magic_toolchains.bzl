"""Module extension for rules_magic toolchains."""

load("@bazel_tools//tools/build_defs/repo:local.bzl", "new_local_repository")
load(
    "@rules_magic//toolchains:repositories.bzl",
    "rules_magic_spells_repositories",
)

def _magic_toolchains_impl(_):
    rules_magic_spells_repositories(
        new_local_repository = new_local_repository,
    )

magic_toolchains = module_extension(
    implementation = _magic_toolchains_impl,
)
