# Bzlmod Bootcamp example

This is the example project for the __Bzlmod Bootcamp__ workshop. It
demonstrates how to migrate [Bazel][] projects using the [legacy WORKSPACE][]
system for configuring [external dependencies][] to the new [Bazel modules][]
system, a.k.a. __Bzlmod__.

## Rationale

Bzlmod is available in Bazel 7 and 8, and [is the only system available in the
upcoming Bazel 9 release][bzlmod-only]. In fact, the latest [rolling releases of
Bazel][rolling] have already removed legacy `WORKSPACE` support, so projects must already fully support Bzlmod to use them.

_Note: [Bzlmod is available to a limited extent in Bazel 6][bzlmod-bazel-6], but
it's missing several important features, such as [use_repo_rule][]. It's worth
migrating to at least Bazel 7 before using it._

## Structure

This [git][] repository contains two separate Bazel repositories:

- [bootcamp][]: A repository that depends upon `rules_bootcamp`
- [rules_bootcamp][]: A rule set repository

Run your IDE from the root of this `git` repository. However, __Bazel
commands for this workshop will run in either the [bootcamp][] or
[rules_bootcamp][] Bazel repositories.__

## Topics

The top level __Bzlmod Bootcamp__ agenda consists of:

- Bzlmod vs. legacy WORKSPACE
- __Bzlmod migration plan__
- Repository name handling for rules consumers
- Fixing and patching repository name handling in rule sets
- Macros vs. Module extensions
- Toolchains (including `protoc`)
- Maintaining minimum version compatibility
- Testing

and the __Bzlmod migration plan__ section specifically consists of:

- Review essential documentation
- Support the latest Bazel 7 release first
- Support the latest Bazel 8, rules_java 8.6.0, protobuf v29.0
- Land Bzlmod fixes while using legacy WORKSPACE
- Land MODULE.bazel last
- _Bonus_: Land backwards compatible Bazel 9 support

## What this workshop is and is _not_

This workshop is _not_ an exhaustive survey of all potential Bzlmod related
issues and migration solutions. It will _not_ cover every item in the official
[Bzlmod migration guide][], including (but not limited to):

- the [Bzlmod migration tool from the Bazel Central Registry][bcr-tool]
- using [WORKSPACE.bzlmod][]

However, it _is_ a survey of the most common Bzlmod migration obstacles, and
insights, strategies, and techniques for overcoming them. It will borrow heavily
from:

- [EngFlow's Bzlmod blog series][blog]
- [rules_scala][] and the [rules_scala Bzlmodification journey][scala-bzlmod]
- [the official Bazel documentation][Bazel]

This foundation will hopefully prove useful for solving specific challenges in
your own projects, however unique the details of those challenges may be.

## Prerequisites

- Familiarity with Bazel
- Some familarity with the legacy `WORKSPACE` external dependency configuration
  system and [how it compares to Bzlmod][workspace-vs-bzlmod]

  - The Bootcamp covers this, but it's good to prepare in advance.

- All the necessary tools already installed on the development machine:
  - [git][]
  - the [Bazelisk][] wrapper for launching specific Bazel versions
  - a C/C++ compiler or development suite, e.g. [gcc][] or [clang][] on Linux,
    [Xcode][] on macOS, or [msvc][] or [clang][] on Windows
  - an IDE of choice, such as [Visual Studio Code][] (ideally with
    [Vim keybindings][])

[Bazel]: https://bazel.build/
[Bazel modules]: https://bazel.build/external/module
[Bazelisk]: https://github.com/bazelbuild/bazelisk?tab=readme-ov-file#installation
[Bzlmod migration guide]: https://bazel.build/external/migration
[Visual Studio Code]: https://code.visualstudio.com/
[Vim keybindings]: https://marketplace.visualstudio.com/items?itemName=vscodevim.vim
[WORKSPACE.bzlmod]: https://bazel.build/external/migration#workspace.bzlmod
[Xcode]: https://developer.apple.com/xcode/
[external dependencies]: https://bazel.build/external/overview
[legacy WORKSPACE]: https://bazel.build/external/overview#workspace-shortcomings
[bcr-tool]: https://bazel.build/external/migration#migration-tool-how-to-use
[blog]: https://blog.engflow.com/category/bzlmod/
[bootcamp]: ./bootcamp/
[bzlmod-bazel-6]: https://bazel.build/versions/6.5.0/external/overview
[bzlmod-only]: https://blog.bazel.build/2023/12/11/bazel-7-release.html#bzlmod
[clang]: https://clang.llvm.org/
[gcc]: https://gcc.gnu.org/
[git]: https://git-scm.com/
[msvc]: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022
[rolling]: https://bazel.build/release/rolling
[rules_bootcamp]: ./rules_bootcamp/
[rules_scala]: https://github.com/bazel-contrib/rules_scala
[scala-bzlmod]: https://github.com/bazel-contrib/rules_scala/issues/1482
[use_repo_rule]: https://bazel.build/rules/lib/globals/module#use_repo_rule
[workspace-vs-bzlmod]: https://blog.engflow.com/2025/01/16/migrating-to-bazel-modules-aka-bzlmod---module-extensions/#module-extensions
