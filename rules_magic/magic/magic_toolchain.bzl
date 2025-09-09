# Copyright 2025 EngFlow, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""https://bazel.build/extending/toolchains"""

load("@com_frobozz_rules_magic//magic:providers.bzl", "MagicInfo")
load(
    "@com_frobozz_rules_magic_config//:config.bzl",
    "MAGIC_VERSION",
    "MAGIC_VERSIONS",
    "ENABLE_SOME_FEATURE",
)

_ATTRS = {
    "version": attr.string(default = MAGIC_VERSION),
    "some_feature": attr.bool(default = ENABLE_SOME_FEATURE),
}

def _magic_toolchain_impl(ctx):
    return [
        platform_common.ToolchainInfo(
            magic_info = MagicInfo(
                version = ctx.attr.version,
                versions = MAGIC_VERSIONS,
                some_feature = ctx.attr.some_feature,
            )
        ),
    ]

magic_toolchain = rule(
    implementation = _magic_toolchain_impl,
    attrs = _ATTRS,
)
