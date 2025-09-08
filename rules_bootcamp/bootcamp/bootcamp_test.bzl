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

"""Implementation of the bootcamp_test rule."""

def _bootcamp_test_impl(ctx):
    executable = ctx.actions.declare_file(ctx.label.name)

    ctx.actions.expand_template(
        template = ctx.file._template,
        is_executable = True,
        output = executable,
        substitutions = {
            "{{src_paths}}": "\n".join(
                ["\"%s\"" % f.path for f in ctx.files.srcs]
            ),
            "{{data_files}}": "\n".join([
                "\"%s\"" % ctx.expand_location(d) for d in ctx.attr.data
            ]),
            "{{test_framework_path}}": ctx.file._test_framework.path,
        },
    )

    dep_attrs = ctx.attr.srcs + ctx.attr.deps
    runfiles_files = ctx.files.srcs + [ctx.file._test_framework]
    runfiles = ctx.runfiles(files = runfiles_files).merge_all([
        target[DefaultInfo].default_runfiles
        for target in dep_attrs
    ])

    return [
        DefaultInfo(
            executable = executable,
            runfiles = runfiles,
        ),
    ]

bootcamp_test = rule(
    implementation = _bootcamp_test_impl,
    doc = "A glorified sh_test",
    # See https://bazel.build/extending/rules#test_rules for implicit
    # dependencies used by Bazel to generate coverage reports.
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(),
        "data": attr.string_list(),
        "_test_framework": attr.label(
            allow_single_file = True,
            default = "//test:test_framework.sh",
        ),
        "_template": attr.label(
            allow_single_file = True,
            default = ":private/test.sh.template",
        ),
    },
    test = True,
)
