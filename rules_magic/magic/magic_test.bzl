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
#
# ---
#
# Copied `_expand_part`, `expand_vars`, and `run_environment_info` from:
# - https://github.com/bazel-contrib/rules_scala/blob/v7.1.4/scala/private/phases/phase_runenvironmentinfo_provider.bzl

"""Implementation of the magic_test rule."""

def _expand_part(ctx, attr_name, part, targets, additional_vars):
    """Perform `$(location)` and "Make variable" substitution for `expand_vars`
    """
    expanded = ctx.expand_location(part, targets)
    return ctx.expand_make_variables(attr_name, expanded, additional_vars)

def expand_vars(ctx, attr_name, value, targets, additional_vars):
    """Perform `$(location)` and "Make variable" substitution on an attribute
    """
    return "$".join([
        _expand_part(ctx, attr_name, s, targets, additional_vars)
        for s in value.split("$$")
    ])

def run_environment_info(ctx):
    """Create a RunEnvironmentInfo provider from `ctx.attr.env` values"""
    targets = getattr(ctx.attr, "data", [])

    return RunEnvironmentInfo(
        environment = {
            k: expand_vars(ctx, "env", v, targets, ctx.var)
            for k, v in ctx.attr.env.items()
        },
        inherited_environment = getattr(ctx.attr, "env_inherit", []),
    )

def _magic_test_impl(ctx):
    executable = ctx.actions.declare_file(ctx.label.name)
    batch_file = None

    ctx.actions.expand_template(
        template = ctx.file._template,
        is_executable = True,
        output = executable,
        substitutions = {
            "{{src_paths}}": "\n".join(
                ["\"%s\"" % f.short_path for f in ctx.files.srcs],
            ),
            "{{test_framework_path}}": ctx.file._test_framework.short_path,
        },
    )

    # Bazel normally adds the executable to the rule's `runfiles` implicitly.
    # However, the executable will be `batch_file` (defined below) on Windows,
    # so we add `executable` explicitly here.
    dep_attrs = ctx.attr.srcs + ctx.attr.deps + ctx.attr.data + [
        ctx.attr._runfiles_lib,
    ]
    runfiles_files = ctx.files.srcs + ctx.files.data + [
        executable,
        ctx.file._test_framework,
    ]
    runfiles = ctx.runfiles(files = runfiles_files).merge_all([
        target[DefaultInfo].default_runfiles
        for target in dep_attrs
    ])

    # Windows can't run Bash scripts directly, so we wrap our main executable in
    # a batch file.
    if ctx.attr.windows == True:
        batch_file = ctx.actions.declare_file(executable.basename + ".bat")
        ctx.actions.write(
            content = "bash " + executable.short_path,
            is_executable = True,
            output = batch_file,
        )

    return [
        DefaultInfo(
            executable = batch_file or executable,
            runfiles = runfiles,
        ),
        run_environment_info(ctx),
    ]

_magic_test = rule(
    implementation = _magic_test_impl,
    doc = "A glorified sh_test with the runfiles prefix included",
    # See https://bazel.build/extending/rules#test_rules for implicit
    # dependencies used by Bazel to generate coverage reports.
    attrs = {
        "data": attr.label_list(allow_files = True),
        "deps": attr.label_list(),
        "env": attr.string_dict(),
        "env_inherit": attr.string_list(),
        "srcs": attr.label_list(allow_files = True),
        "windows": attr.bool(),
        "_runfiles_lib": attr.label(
            default = "@bazel_tools//tools/bash/runfiles",
        ),
        "_template": attr.label(
            allow_single_file = True,
            default = ":private/test.sh.template",
        ),
        "_test_framework": attr.label(
            allow_single_file = True,
            default = "//test:test_framework.sh",
        ),
    },
    test = True,
)

def magic_test(**kwargs):
    _magic_test(
        windows = select({
            Label("@platforms//os:windows"): True,
            "//conditions:default": False,
        }),
        **kwargs
    )
