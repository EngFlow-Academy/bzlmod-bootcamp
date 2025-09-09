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

"""magic_digests implementation"""

_ATTRS = {
    "deps": attr.label_list(
        allow_files = True,
        mandatory = True,
    ),
    "worker": attr.label(
        default = Label("//src/com/frobozz/magic:EmitDigestsWorker"),
        executable = True,
        cfg = "exec",
    ),
}

def _magic_digests_impl(ctx):
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
        mnemonic = "MagicDigests",
        execution_requirements = {
            "supports-workers" : "1",
        },
        arguments = [args],
    )

    return DefaultInfo(files = depset(outputs))

magic_digests = rule(
    implementation = _magic_digests_impl,
    attrs = _ATTRS,
)
