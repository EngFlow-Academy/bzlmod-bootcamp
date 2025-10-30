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

"""Toolchain provider definitions

See: https://bazel.build/extending/rules#providers
"""

MagicInfo = provider(
    "Configured values for the rules_magic toolchain",
    fields = {
        "game": "string identifying the game providing these spells",
        "games": "strings identifying all configured games",
        "some_feature": "boolean indicating enablement of some_feature",
        "spells_json": "path to JSON file describing spells from this game",
        "version": "string identifying the rules_magic version",
        "versions": "strings identifying all valid rules_magic versions",
    },
)
