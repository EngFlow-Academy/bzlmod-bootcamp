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

"""Defines the repository rule for @io_frobozzco_rules_bootcamp_leaflet."""

_LEAFLET_CONTENT = """\
In the interest of avoiding a potential copyright violation, please search for
"read leaflet" in the following document and read the contents from there:

https://web.mit.edu/marleigh/www/portfolio/Files/zork/transcript.html
"""

_BUILD_CONTENT = """\
alias(
    name = "%s",
    actual = "leaflet.txt",
    visibility = ["//visibility:public"],
)
"""

def _bootcamp_leaflet_repo_impl(rctx):
    rctx.file("leaflet.txt", _LEAFLET_CONTENT, executable = False)
    rctx.file("BUILD", _BUILD_CONTENT % rctx.name, executable = False)

bootcamp_leaflet_repo = repository_rule(
    implementation = _bootcamp_leaflet_repo_impl,
)
