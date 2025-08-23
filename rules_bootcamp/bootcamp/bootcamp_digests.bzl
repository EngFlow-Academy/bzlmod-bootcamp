"""bootcamp_digests implementation"""

_ATTRS = {
    "deps": attr.label_list(
        allow_files = True,
        mandatory = True,
    ),
    "worker": attr.label(
        default = Label("//src/io/frobozzco/bootcamp:EmitDigestsWorker"),
        executable = True,
        cfg = "exec",
    ),
}

def _bootcamp_digests_impl(ctx):
    args = ctx.actions.args()
    args.set_param_file_format("multiline")
    args.use_param_file(param_file_arg = "@%s", use_always = True)

    # https://bazel.build/rules/lib/builtins/ctx#outputs
    # https://bazel.build/extending/rules#requesting_output_files
    # https://bazel.build/extending/rules#deprecated_predeclared_outputs
    outputs = [ctx.actions.declare_file(ctx.label.name + "-digests.txt")]
    args.add_all(outputs)

    ctx.actions.run(
        inputs = ctx.files.deps,
        outputs = outputs,
        executable = ctx.executable.worker,
        mnemonic = "BootcampDigests",
        execution_requirements = {
            "supports-workers" : "1",
        },
        arguments = [args],
    )

    return DefaultInfo(files = depset(outputs))

bootcamp_digests = rule(
    implementation = _bootcamp_digests_impl,
    attrs = _ATTRS,
)
