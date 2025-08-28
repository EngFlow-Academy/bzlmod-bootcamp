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

load(":deps.bzl", _rules_magic_deps = "rules_magic_deps")
load(":magic_digests.bzl", _magic_digests = "magic_digests")
load(":magic_library.bzl", _magic_library = "magic_library")
load(
    ":magic_spells_repository.bzl",
    _magic_spells_repository = "magic_spells_repository",
)
load(":magic_test.bzl", _magic_test = "magic_test")
load(":magic_toolchain.bzl", _magic_toolchain = "magic_toolchain")
load(
    ":private/magic_leaflet_repository.bzl",
    _magic_leaflet_repository = "magic_leaflet_repository",
)
load(
    ":private/setup_magic_spells_repositories.bzl",
    "setup_magic_spells_repositories",
)
load(
    ":private/setup_magic_toolchain.bzl",
    _setup_magic_toolchain = "setup_magic_toolchain",
)

magic_binary = native.java_binary
magic_digests = _magic_digests
magic_library = _magic_library
magic_spells_repository = _magic_spells_repository
magic_test = _magic_test
magic_toolchain = _magic_toolchain
rules_magic_deps = _rules_magic_deps
setup_magic_toolchain = _setup_magic_toolchain

def rules_magic_leaflet_repository(name = "rules_magic_leaflet"):
    """Instantiates the @rules_magic_leaflet repository.

    Args:
        name: the name of the magic leaflet repository
    """
    _magic_leaflet_repository(name = name)

def rules_magic_toolchains(name = None):
    """Instantiates toolchain dependencies and registers builtin toolchains.

    Args:
        name: unused; defined to satisfy buildifier
    """
    setup_magic_spells_repositories(name = name)
    native.register_toolchains("//magic:all")
