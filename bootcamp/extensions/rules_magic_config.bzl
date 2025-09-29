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

"""Client-side module extension for @rules_magic_config"""

load(
    "@rules_magic//magic:config.bzl",
    "CONFIG_ATTRS",
    _magic_config = "magic_config",
)

_tag_classes = {
    "settings": tag_class(
        attrs = CONFIG_ATTRS,
        doc = "`rules_magic` configuration parameters",
    ),
}

def _magic_config_impl(module_ctx):
    for mod in module_ctx.modules:
        if mod.is_root:
            # This module is by definition the root module.
            settings = mod.tags.settings[0]
            _magic_config(
                game = settings.game,
                games = settings.games,
                version = settings.version,
                versions = settings.versions,
                enable_some_feature = settings.enable_some_feature,
            )
            break

    return module_ctx.extension_metadata(reproducible = True)

magic_config = module_extension(
    implementation = _magic_config_impl,
    tag_classes = _tag_classes,
    doc = (
        "Configures core `rules_scala` parameters and exports them via the " +
        "`@rules_scala_config` repository"
    ),
)
