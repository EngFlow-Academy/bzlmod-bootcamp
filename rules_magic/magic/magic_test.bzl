"""Implementation of the magic_test rule.

Lifted `_expand_part`, `expand_vars`, and `run_environment_info` from
rules_scala's `scala/private/phases/phase_runenvironmentinfo_provider.bzl`.
"""

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
    # Replace `[]` with `getattr(ctx.attr, "data", [])` later in the workshop.
    targets = []

    return RunEnvironmentInfo(
        environment = {
            k: expand_vars(ctx, "env", v, targets, ctx.var)
            for k, v in ctx.attr.env.items()
        },
        inherited_environment = getattr(ctx.attr, "env_inherit", []),
    )

def _magic_test_impl(ctx):
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
            "{{test_framework_path}}": ctx.file._test_framework.short_path,
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
        run_environment_info(ctx),
    ]

magic_test = rule(
    implementation = _magic_test_impl,
    doc = "A glorified sh_test",
    # See https://bazel.build/extending/rules#test_rules for implicit
    # dependencies used by Bazel to generate coverage reports.
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "deps": attr.label_list(),
        "data": attr.string_list(),
        "env": attr.string_dict(),
        "env_inherit": attr.string_list(),
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
