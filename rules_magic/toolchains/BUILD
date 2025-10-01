"""Toolchain definitions"""
package(default_visibility = ["//visibility:public"])

exports_files(["providers.bzl"])

# Toolchains of this type must return a `ToolchainInfo` object with the
# `MagicInfo` provider from `providers.bzl`:
#
#   ToolchainInfo(
#       magic_info = MagicInfo(...),
#   )
toolchain_type(name = "toolchain_type")
