"""Bootcamp rules and macros"""

_ATTRS = {
    "version": attr.string(),
    "some_feature": attr.bool(),
    "java_compile_toolchain": attr.label(
        default = "@bazel_tools//tools/jdk:current_java_toolchain",
        providers = [java_common.JavaToolchainInfo],
    ),
    "_template": attr.label(
        allow_single_file = True,
        default = ":private/bootcamp.java.template",
    ),
}

_TOOLCHAIN_TYPE = "@io_frobozzco_rules_bootcamp//bootcamp:toolchain_type"

def _bootcamp_library_impl(ctx):
    info = ctx.toolchains[_TOOLCHAIN_TYPE].bootcamp_info
    version = ctx.attr.version or info.version
    some_feature = getattr(ctx.attr, "some_feature", info.some_feature)

    if version not in info.versions:
        fail("rules_bootcamp version %s not in: %s" % (version, info.versions))

    class_name = ctx.label.name.replace("-", "_")
    class_name = "".join([s.capitalize() for s in class_name.split("_")])
    src_file = ctx.actions.declare_file(class_name + ".java")

    ctx.actions.expand_template(
        template = ctx.file._template,
        output = src_file,
        substitutions = {
            "{{class_name}}": class_name,
            "{{version}}": version,
            "{{versions}}": str(info.versions)[1:-1],
            "{{some_feature_enabled}}": str(some_feature).lower(),
        },
    )

    output_jar = ctx.actions.declare_file(class_name + ".jar")
    compile_toolchain = ctx.attr.java_compile_toolchain
    return [
        DefaultInfo(files = depset([output_jar])),
        java_common.compile(
            ctx,
            output = output_jar,
            java_toolchain = compile_toolchain[java_common.JavaToolchainInfo],
            source_files = [src_file],
        ),
    ]

bootcamp_library = rule(
    implementation = _bootcamp_library_impl,
    attrs = _ATTRS,
    fragments = ["java"],
    toolchains = [_TOOLCHAIN_TYPE],
)
