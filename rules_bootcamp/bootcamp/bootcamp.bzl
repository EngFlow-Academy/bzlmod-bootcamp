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

"""rules_bootcamp public API"""

load(
    "@io_frobozzco_rules_bootcamp//bootcamp:bootcamp_digests.bzl",
    _bootcamp_digests = "bootcamp_digests",
)
load(
    "@io_frobozzco_rules_bootcamp//bootcamp:bootcamp_library.bzl",
    _bootcamp_library = "bootcamp_library",
)
load(
    "@io_frobozzco_rules_bootcamp//bootcamp:deps.bzl",
    _rules_bootcamp_deps = "rules_bootcamp_deps",
)
load(
    "@io_frobozzco_rules_bootcamp//bootcamp:toolchains.bzl",
    _rules_bootcamp_toolchains = "rules_bootcamp_toolchains",
)

bootcamp_digests = _bootcamp_digests
bootcamp_library = _bootcamp_library
rules_bootcamp_deps = _rules_bootcamp_deps
rules_bootcamp_toolchains = _rules_bootcamp_toolchains
