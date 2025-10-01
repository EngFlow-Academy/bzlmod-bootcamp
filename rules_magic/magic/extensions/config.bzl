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
# Modeled after:
# - https://github.com/bazel-contrib/rules_scala/blob/v7.1.4/scala/extensions/config.bzl

"""Module extension to generate the @rules_magic_config repo."""

load(
    "//magic:config.bzl",
    "CONFIG_ATTRS",
    "CONFIG_DEFAULTS",
    "CONFIG_ENVIRON",
    _magic_config = "magic_config",
)
load(":private/bzlmod.bzl", "root_module_settings")

_tag_classes = {
    "settings": tag_class(
        attrs = CONFIG_ATTRS,
        doc = "`rules_magic` configuration parameters",
    ),
}

def _magic_config_impl(module_ctx):
    settings = root_module_settings(module_ctx, CONFIG_DEFAULTS)

    menv = module_ctx.os.environ
    game = menv.get("MAGIC_GAME", settings["game"])
    version = menv.get("MAGIC_VERSION", settings["version"])

    _magic_config(
        game = game,
        games = settings["games"] or [game],
        version = version,
        versions = settings["versions"] or [version],
        enable_some_feature = menv.get(
            "ENABLE_SOME_FEATURE",
            settings["enable_some_feature"],
        ),
    )
    return module_ctx.extension_metadata(reproducible = True)

magic_config = module_extension(
    implementation = _magic_config_impl,
    tag_classes = _tag_classes,
    environ = CONFIG_ENVIRON,
    doc = (
        "Configures core `rules_scala` parameters and exports them via the " +
        "`@rules_scala_config` repository"
    ),
)
