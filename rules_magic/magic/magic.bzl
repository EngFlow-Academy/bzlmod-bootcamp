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

"""rules_magic public API"""

load(
    "@com_frobozz_rules_magic//magic:magic_digests.bzl",
    _magic_digests = "magic_digests",
)
load(
    "@com_frobozz_rules_magic//magic:magic_library.bzl",
    _magic_library = "magic_library",
)
load(
    "@com_frobozz_rules_magic//magic:magic_test.bzl",
    _magic_test = "magic_test",
)
load(
    "@com_frobozz_rules_magic//magic:deps.bzl",
    _rules_magic_deps = "rules_magic_deps",
)
load(
    "@com_frobozz_rules_magic//magic:private/magic_leaflet_repository.bzl",
    _magic_leaflet_repository = "magic_leaflet_repository",
)
load(
    "@com_frobozz_rules_magic//magic:toolchains.bzl",
    _rules_magic_toolchains = "rules_magic_toolchains",
)
magic_digests = _magic_digests
magic_library = _magic_library
magic_test = _magic_test
rules_magic_deps = _rules_magic_deps
rules_magic_toolchains = _rules_magic_toolchains

def rules_magic_leaflet_repository(name = "com_frobozz_rules_magic_leaflet"):
    """Instantiates the @rules_magic_leaflet repository.

    Args:
        name: the name of the magic leaflet repository
    """
    _magic_leaflet_repository(name = name)
