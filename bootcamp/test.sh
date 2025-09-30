#!/usr/bin/env bash
#
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

test_leaflet_exists() {
  local leaflet_path="${DATA_FILES[0]}"

  if [[ -z "$leaflet_path" ]]; then
    echo "No leaflet_path specified."
    exit 1
  elif [[ ! -f "$leaflet_path" ]]; then
    echo "leaflet_path does not exist: ${leaflet_path}"
    exit 1
  fi

  printf 'Contents of "%s":\n---\n%s\n---\n' \
    "${leaflet_path}" "$(< ${leaflet_path})"
}
