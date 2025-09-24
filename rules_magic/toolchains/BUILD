"""Toolchain definitions"""
load("@com_frobozz_rules_magic//toolchains:repositories.bzl", "KNOWN_GAMES")
load(
    "@com_frobozz_rules_magic//toolchains:toolchains.bzl",
    "setup_magic_toolchain",
)

package(default_visibility = ["//visibility:public"])

exports_files(["providers.bzl"])

# Toolchains of this type must return a `ToolchainInfo` object with the
# `MagicInfo` provider from `providers.bzl`:
#
#   ToolchainInfo(
#       magic_info = MagicInfo(...),
#   )
toolchain_type(name = "toolchain_type")

setup_magic_toolchain(name = "default_settings_toolchain")

[
    setup_magic_toolchain(
        name = game + "_toolchain",
        game = game,
    )
    for game in KNOWN_GAMES
]
