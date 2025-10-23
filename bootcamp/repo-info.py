#!/usr/bin/env python3
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

import argparse
import ast
import json
import sys

_DESCRIPTION = """\
Summarizes repository info from --experimental_repository_resolved_file output\
"""

_EPILOG = """\
Before running this script, run the following, where 'out.bzl' becomes the
'resolved_file' argument to this script:

  bazel clean --expunge_async
  bazel build --nobuild --noenable_bzlmod --enable_workspace \\
    --experimental_repository_resolved_file=out.bzl //...
"""

parser = argparse.ArgumentParser(
    description=_DESCRIPTION,
    epilog=_EPILOG,
    formatter_class=argparse.RawDescriptionHelpFormatter,
)
parser.add_argument(
	'-v',
    '--verbose',
    action='store_true',
    help='show definition_information and original_attributes',
)
parser.add_argument(
    '--json',
    action='store_true',
    help='output as JSON for further processing (e.g., using \'jq\')',
)
parser.add_argument(
    'resolved_file',
    help='path to --experimental_repository_resolved_file output',
)
parser.add_argument(
	'repository',
	nargs='+',
    help='one or more repository names to examine',
)
args = parser.parse_args()

# Set up dicts to use the same repo ordering in the output as in argv.
repos = {r: None for r in args.repository}
result = {r: None for r in args.repository}

with open(args.resolved_file, 'r', encoding='utf-8') as f:
    resolved = f.read()
resolved = resolved.removeprefix('resolved = ')
resolved = ast.literal_eval(resolved)

# `resolved` contains a list of dicts representing each repo.
for repo in resolved:
    attrs = repo['original_attributes']
    name = attrs['name']

    if name not in repos:
        continue

    if args.json:
        result[name] = repo
    elif args.verbose:
        result[name] = '\n'.join([
            name + ':',
            repo.get('definition_information', 'No definition_information'),
            json.dumps(attrs, indent=4),
            '',
        ])
    else:
        src = attrs.get('path') or attrs.get('url') or attrs.get('urls')
        result[name] = f'{name}: {src}'

    del repos[name]
    if len(repos) == 0:
        break

result = [v for v in result.values() if v is not None]

if args.json:
    print(json.dumps(result, indent=4))
else:
    for v in result:
        print(v)

if repos:
    print('repo(s) not found: ' + ', '.join(repos.keys()), file=sys.stderr)
    sys.exit(len(repos))
