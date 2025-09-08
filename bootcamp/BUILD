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
    "@io_frobozzco_rules_bootcamp//bootcamp:bootcamp.bzl",
    "bootcamp_digests",
    "bootcamp_library",
    "bootcamp_test",
)

bootcamp_library(
    name = "default-values",
)

genrule(
    name = "expansions",
    srcs = ["@io_frobozzco_rules_bootcamp_leaflet"],
    outs = ["expansions.txt"],
    cmd = "\n".join([
        "echo {f}: $({f} @io_frobozzco_rules_bootcamp_leaflet) >>$@".format(f = f)
        for f in ["execpath", "rootpath", "location"]
    ])
)

bootcamp_digests(
    name = "hello",
    deps = [
        ":default-values",
        ":expansions",
        ":hello.txt",
        "@io_frobozzco_rules_bootcamp_leaflet",
    ],
)

bootcamp_test(
    name = "example_test",
    srcs = ["test.sh"],
    deps = ["@io_frobozzco_rules_bootcamp_leaflet"],
    data = ["$(location @io_frobozzco_rules_bootcamp_leaflet)"],
)
