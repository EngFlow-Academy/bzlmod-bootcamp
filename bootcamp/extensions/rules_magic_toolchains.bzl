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

"""Module extension for rules_magic toolchains."""

load(
    "@rules_magic//magic:private/setup_magic_spells_repositories.bzl",
    "setup_magic_spells_repositories",
)

def _magic_toolchains_impl(module_ctx):
    setup_magic_spells_repositories()
    return module_ctx.extension_metadata(reproducible = True)

magic_toolchains = module_extension(
    implementation = _magic_toolchains_impl,
)
