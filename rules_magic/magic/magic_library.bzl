"""magic_library implementation"""

_ATTRS = {
    "version": attr.string(),
    "java_compile_toolchain": attr.label(
        default = "@rules_java//toolchains:toolchain_jdk_17",
        providers = [java_common.JavaToolchainInfo],
    ),
    "_template": attr.label(
        allow_single_file = True,
        default = ":private/magic.java.template",
    ),
}

_TOOLCHAIN_TYPE = "@com_frobozz_rules_magic//toolchains:toolchain_type"

def _magic_library_impl(ctx):
    info = ctx.toolchains[_TOOLCHAIN_TYPE].magic_info
    version = ctx.attr.version or info.version
    some_feature = info.some_feature

    if version not in info.versions:
        fail("rules_magic version %s not in: %s" % (version, info.versions))

    class_name = ctx.label.name.replace("-", "_")
    class_name = "".join([s.capitalize() for s in class_name.split("_")])
    src_file = ctx.actions.declare_file(class_name + ".java")
    spells_json = info.spells_json[DefaultInfo].files.to_list()[0]

    ctx.actions.expand_template(
        template = ctx.file._template,
        output = src_file,
        substitutions = {
            "{{class_name}}": class_name,
            "{{version}}": version,
            "{{versions}}": str(info.versions)[1:-1],
            "{{game}}": info.game,
            "{{games}}": str(info.games)[1:-1],
            "{{some_feature_enabled}}": str(some_feature).lower(),
            "{{spells_json}}": spells_json.path,
        },
    )

    output_jar = ctx.actions.declare_file(class_name + ".jar")
    compile_toolchain = ctx.attr.java_compile_toolchain

    return [
        DefaultInfo(
            files = depset([output_jar]),
            runfiles = ctx.runfiles(files = [spells_json]),
        ),
        java_common.compile(
            ctx,
            output = output_jar,
            java_toolchain = compile_toolchain[java_common.JavaToolchainInfo],
            source_files = [src_file],
        ),
    ]

magic_library = rule(
    implementation = _magic_library_impl,
    attrs = _ATTRS,
    fragments = ["java"],
    provides = [JavaInfo],
    toolchains = [
        _TOOLCHAIN_TYPE,
        "@bazel_tools//tools/jdk:toolchain_type",
    ],
)
