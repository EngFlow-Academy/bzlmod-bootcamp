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

"""Bootcamp rules and macros"""

load("@rules_java//java:defs.bzl", "java_test")

_ATTRS = {
    # TODO: Make this configurable by the config repo.
    "test_class": attr.string(),
}

def _bootcamp_library_impl(ctx):
    pass

bootcamp_library = rule(
    implementation = _bootcamp_library_impl,
    attrs = _ATTRS,
    toolchains = ["//bootcamp:toolchain_type"],
)

def bootcamp_test(name, **kwargs):
    lib_name = name + "_bootcamp_library"

    java_test(
        name = name,
        deps = kwargs.pop("deps", []) + [lib_name],
        **kwargs
    )

    bootcamp_library(
        name = lib_name,
    )
