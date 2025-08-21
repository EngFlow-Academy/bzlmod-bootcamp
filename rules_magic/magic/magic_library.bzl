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

"""magic_library implementation"""

_ATTRS = {
    "java_compile_toolchain": attr.label(
        default = "@bazel_tools//tools/jdk:toolchain_jdk_17",
        providers = [java_common.JavaToolchainInfo],
    ),
    "version": attr.string(),
    "_template": attr.label(
        allow_single_file = True,
        default = ":private/magic.java.template",
    ),
}

_TOOLCHAIN_TYPE = "@com_frobozz_rules_magic//magic:toolchain_type"

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
            "{{games}}": str(info.games)[1:-1],
            "{{game}}": info.game,
            "{{some_feature_enabled}}": str(some_feature).lower(),
            "{{spells_json}}": spells_json.path,
            "{{versions}}": str(info.versions)[1:-1],
            "{{version}}": version,
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
