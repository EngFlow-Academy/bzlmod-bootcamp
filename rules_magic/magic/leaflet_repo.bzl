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

"""Legacy WORKSPACE macro for instantiating @rules_magic_leaflet."""

load(
    "//magic:private/magic_leaflet_repository.bzl",
    _magic_leaflet_repository = "magic_leaflet_repository",
)

def rules_magic_leaflet_repository(name = "rules_magic_leaflet"):
    """Instantiates the @rules_magic_leaflet repository.

    For legacy WORKSPACE builds only. For Bzlmod, use
    //magic/extensions:leaflet_repo.bzl.

    Args:
        name: the name of the magic leaflet repository
    """
    _magic_leaflet_repository(name = name)
