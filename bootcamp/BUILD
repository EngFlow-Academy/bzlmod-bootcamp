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

load(
    "@com_frobozz_rules_magic//magic:magic.bzl",
    "magic_digests",
    "magic_library",
    "magic_test",
)

magic_library(
    name = "default-values",
)

genrule(
    name = "expansions",
    srcs = ["@com_frobozz_rules_magic_leaflet"],
    outs = ["expansions.txt"],
    cmd = "\n".join([
        "echo {f}: $({f} @com_frobozz_rules_magic_leaflet) >>$@".format(f = f)
        for f in ["execpath", "rootpath", "location"]
    ])
)

magic_digests(
    name = "hello",
    deps = [
        ":default-values",
        ":expansions",
        ":hello.txt",
        "@com_frobozz_rules_magic_leaflet",
    ],
)

magic_test(
    name = "example_test",
    srcs = ["test.sh"],
    deps = ["@com_frobozz_rules_magic_leaflet"],
    data = ["$(location @com_frobozz_rules_magic_leaflet)"],
)
