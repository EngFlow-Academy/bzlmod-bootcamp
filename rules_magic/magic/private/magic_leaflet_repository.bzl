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

"""Defines the repository rule for @rules_magic_leaflet."""

_LEAFLET_CONTENT = """\
In the interest of avoiding a potential copyright violation, please search for
"read leaflet" in the following document and read the contents from there:

https://web.mit.edu/marleigh/www/portfolio/Files/zork/transcript.html
"""

# buildifier: disable=canonical-repository
_BUILD_CONTENT = """\
load(
    "@@{rules_magic_repo}//magic:private/magic_leaflet.bzl",
    "magic_leaflet",
)

magic_leaflet(
    name = "{leaflet_name}",
    text = "leaflet.txt",
    visibility = ["//visibility:public"],
)
"""

_RULES_MAGIC_REPO = Label("//:all").repo_name

def _magic_leaflet_repository_impl(rctx):
    rctx.file("leaflet.txt", _LEAFLET_CONTENT, executable = False)
    rctx.file(
        "BUILD",
        _BUILD_CONTENT.format(
            rules_magic_repo = _RULES_MAGIC_REPO,
            leaflet_name = rctx.name,
        ),
        executable = False,
    )

magic_leaflet_repository = repository_rule(
    implementation = _magic_leaflet_repository_impl,
)
