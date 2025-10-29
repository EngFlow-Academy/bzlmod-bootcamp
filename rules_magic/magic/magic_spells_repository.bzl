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

"""Repo rule for instantiating a toolchain dependency repo."""

_BUILD_FILE = """\
exports_files(["spells.json"])

alias(
    name = "{repo_name}",
    actual = ":spells.json",
    visibility = ["//visibility:public"],
)
"""

def _magic_spells_repository_impl(rctx):
    # Replace with rctx.original_name once all supported Bazels have it.
    repo_name = getattr(rctx, "original_name", rctx.attr.default_target_name)
    rctx.file(
        "BUILD",
        content = _BUILD_FILE.format(repo_name = repo_name),
        executable = False,
    )
    rctx.symlink(
        rctx.path(rctx.attr.spells_json),
        "spells.json",
    )

_magic_spells_repository = repository_rule(
    implementation = _magic_spells_repository_impl,
    attrs = {
        # Remove once all supported Bazels have repository_ctx.original_name.
        "default_target_name": attr.string(mandatory = True),
        "spells_json": attr.label(
            allow_single_file = [".json"],
            mandatory = True,
        ),
    },
)

def magic_spells_repository(name, **kwargs):
    _magic_spells_repository(
        name = name,
        default_target_name = name,
        **kwargs
    )
