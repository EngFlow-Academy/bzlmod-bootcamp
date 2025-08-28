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

"""Module extension to generate the @rules_magic_leaflet_repo repo."""

load("//magic:magic.bzl", "rules_magic_leaflet_repository")

def _magic_leaflet_impl(mctx):
    rules_magic_leaflet_repository()
    return mctx.extension_metadata(reproducible = True)

magic_leaflet = module_extension(
    implementation = _magic_leaflet_impl,
)
