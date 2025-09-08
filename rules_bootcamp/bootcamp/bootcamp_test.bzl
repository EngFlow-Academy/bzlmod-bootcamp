"""Implementation of the bootcamp_test rule."""

_PREAMBLE = """\
#!/usr/bin/env bash

"""

def _test_file_block(f, data_files):
    return "\n".join([
        "echo \"Executing: '%s'\"" % f.short_path,
        ". \"%s\" %s" % (f.path, " ".join(data_files)),
        "echo\n",
    ])

def _make_script(ctx):
    return _PREAMBLE + "\n".join([
        _test_file_block(f, [ctx.expand_location(d) for d in ctx.attr.data])
        for f in ctx.files.srcs
    ])

def _bootcamp_test_impl(ctx):
    executable = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.write(executable, _make_script(ctx), is_executable = True)

    dep_attrs = ctx.attr.srcs + ctx.attr.deps
    runfiles = ctx.runfiles(files = ctx.files.srcs).merge_all([
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
    },
    test = True,
)
