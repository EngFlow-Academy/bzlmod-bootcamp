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

load("@io_frobozzco_rules_bootcamp//bootcamp:providers.bzl", "BootcampInfo")
load(
    "@io_frobozzco_rules_bootcamp_config//:config.bzl",
    "BOOTCAMP_VERSION",
    "BOOTCAMP_VERSIONS",
    "ENABLE_SOME_FEATURE",
)

_ATTRS = {
    "version": attr.string(default = BOOTCAMP_VERSION),
    "some_feature": attr.bool(default = ENABLE_SOME_FEATURE),
}

def _bootcamp_toolchain_impl(ctx):
    return [
        platform_common.ToolchainInfo(
            bootcamp_info = BootcampInfo(
                version = ctx.attr.version,
                versions = BOOTCAMP_VERSIONS,
                some_feature = ctx.attr.some_feature,
            )
        ),
    ]

bootcamp_toolchain = rule(
    implementation = _bootcamp_toolchain_impl,
    attrs = _ATTRS,
)
