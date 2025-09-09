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

load("@com_frobozz_rules_magic//magic:magic.bzl", "magic_library")
load("@com_frobozz_rules_magic//magic:magic_toolchain.bzl", "magic_toolchain")

exports_files(
    [
        "private/magic.java.template",
        "private/test.sh.template",
    ],
    visibility = [":__pkg__"],
)

toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

magic_toolchain(
    name = "default_settings",
)

toolchain(
    name = "default_settings_toolchain",
    toolchain = ":default_settings",
    toolchain_type = ":toolchain_type",
)

magic_library(
    name = "default-values",
)
