"""Module extension for rules_magic toolchains."""

load("//toolchains:repositories.bzl", "rules_magic_spells_repositories")
load("@bazel_tools//tools/build_defs/repo:local.bzl", "new_local_repository")

def _magic_toolchains_impl(mctx):
    rules_magic_spells_repositories(
      new_local_repository = new_local_repository,
    )

magic_toolchains = module_extension(
    implementation = _magic_toolchains_impl,
)
