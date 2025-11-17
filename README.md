# Bzlmod Migration Bootcamp

This is the example project for the __Bzlmod Migration Bootcamp__ workshop. It
demonstrates how to migrate [Bazel][] projects using the [legacy WORKSPACE][]
system for configuring [external dependencies][] to the new [Bazel modules][]
system, a.k.a. __Bzlmod__.

It also shows how to:

- Solve common problems that arise when migrating to newer Bazel versions
- Implement the "hub repo" pattern to better encapsulate toolchains and their
    dependencies
- Maintain compatibility with a wide range of Bazel versions and dependency
    versions
- Write and run tests to validate rule behaviors, including failure behaviors
- Write and run tests to validate version compatibility contracts

## Video

This is the video of the Bzlmod Migration Bootcamp v1.0.0 presented at BazelCon
in Atlanta, GA on 2025-11-09:

[![Thumbnail for the Bzlmod Migration Bootcamp video][bc-vid-img]][bc-vid]

## Slides

See the __[Releases][]__ page for official releases of the accompanying slides
in PDF format.

This is how the versioned slides stay in sync with the corresponding code:

- Each official release will correspond to a version tag for this repository of
    the form `v[Major].[minor].[patch]`.

- Each example project [milestone](#milestones) for that release will have its
    own versioned tag name of the form `v[Major].[minor].[patch]-[milestone]`.

- The slides will contain links to commit lists and source files that include
    the versioned tag name of the relevant milestone. This way each release of
    the slides will contain stable links to the corresponding version of the
    example repo.

## Rationale

Bzlmod is available in Bazel 7 and 8, and [is the only system available in the
upcoming Bazel 9 release][bzlmod-only]. In fact, the latest [rolling releases of
Bazel][rolling] have already removed legacy `WORKSPACE` support, so projects
must already fully support Bzlmod to use them.

_Note: [Bzlmod is available to a limited extent in Bazel 6][bzlmod-bazel-6], but
it's missing several important features, such as [use_repo_rule][]. It's worth
migrating to at least Bazel 7 before using it._

## Structure

This [Git repository][] contains two separate [Bazel repositories][]:

- [bootcamp][]: A repository that depends upon `rules_magic`
- [rules_magic][]: A rule set repository reminiscent of [FrobozzCo
  International][] products

Run your IDE from the root of this `bzlmod-bootcamp` Git repository. However,
__Bazel commands for this workshop will run in the [bootcamp][] Bazel
repository.__

## Topics

The top level __Bzlmod Migration Bootcamp__ agenda consists of:

- Bzlmod vs. legacy WORKSPACE
- Module extensions
- __Bzlmod migration plan__
- Repository name handling
- Patching dependencies
- Encapsulating toolchains
- Testing
- Dependency version compatibility

and the __Bzlmod migration plan__ section specifically consists of:

- Review essential documentation, clarify priorities & decisions
- Migrate to Bazel 7 first (Bazel 6 Bzlmod support is incomplete)
- __Optional:__ Fix everything on a branch, open a separate pull request for
  each fix (rebase after merging each PR into main)
- __Optional:__ Migrate to Bazel 8 first, remove own repo references
- Keep legacy `WORKSPACE` building; enable Bzlmod at the end
- Inspiration + evidence: bazel-contrib/rules_scala#1482

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

- Familiarity with [Bazel][]
- Some familarity with the legacy `WORKSPACE` external dependency configuration
  system and [how it compares to Bzlmod][workspace-vs-bzlmod]

  - The Bootcamp covers this, but it's good to prepare in advance.

- All the necessary tools already installed on the development machine:
  - [git][]
    - [git-for-windows][] on Windows, as this project requires [Bash][]
  - the [Bazelisk][] wrapper for launching specific Bazel versions
  - a C/C++ compiler or development suite, e.g. [gcc][] or [clang][] on Linux,
    [Xcode][] on macOS, or [msvc][] or [clang][] on Windows
  - an IDE of choice, such as [Visual Studio Code][] (ideally with
    [Vim keybindings][])

## Milestones

Git branches and tags identify significant points throughout the migration
process whereby a subset of changes within the overall history achieves a
specific outcome. We call those points and the branches and tags that identify
them "milestones."

- Milestone branches are subject to change at any time as the course evolves.
    The `main` branch corresponds to the latest development version of the
    `compatibility` milestone.

- Milestone tags have the form `v[Major].[minor].[patch]-[milestone]`. They will
    remain stable to ensure links from the corresponding [slide deck](#slides)
    version remain intact.

While many of the changes throughout the commit history could happen in any
order, milestones help put specific collections of commits within context. For
example, the commits after the `bazel-7` milestone and including the `bazel-8`
milestone specifically demonstrate Bazel 8 compatibility issues and fixes.

The table below illustrates how the migration process makes the project
compatible with newer Bazels, and eventually Bzlmod, without sacrificing
backward compatibility. The milestones comprising the process appear in reverse
chronological order, as they would appear in `git log`. Each milestone builds on
the milestone below it, with one exception:

- The `bzlmod-client-patches` milestone is based on the `own-repo-names`
  milestone, the same as `bzlmod`.

- `bzlmod` shows how to update the [rules_magic][] rule set repository to make
    it Bzlmod compatible. This is the preferred migration path.

- `bzlmod-client-patches` shows how to update the [bootcamp][] repository to
    make it Bzlmod compatible when `rules_magic` _is not_ itself Bzlmod
    compatible. This involves creating patches and module extensions for
    `rules_magic` within the `bootcamp` repository/Bazel module. This is not the
    preferred migration path, but demonstrates how a client repository can adapt
    a non-Bzlmod compatible dependency to build under Bzlmod.

| Milestone | Bazel versions | Legacy `WORKSPACE` | Bzlmod |
| :-: | :-: | :-: | :-: |
| `compatibility` | 6, 7, 8, `rolling`, `last_green` | &#x2705; | &#x2705; |
| `toolchains` | 6, 7, 8, `rolling`, `last_green` | &#x2705; | &#x2705; |
| `bazel-9` | 6, 7, 8, `rolling`, `last_green` | &#x2705; | &#x2705; |
| `bzlmod-client-patches` | 6, 7, 8 | &#x2705; | &#x2705; |
| `bzlmod` | 6, 7, 8 | &#x2705; | &#x2705; |
| `own-repo-names` | 6, 7, 8 | &#x2705; | |
| `bazel-8` | 6, 7, 8 | &#x2705; | |
| `bazel-7` | 6, 7 | &#x2705; | |
| `bazel-6` | 6 | &#x2705; | |

## Viewing the commit history

It's helpful to view the commit history in your Git commit history viewer of
choice, such as [gitk][] or [tig][]. The summary lines in the commit history
list provide a good overview of the migration process and the individual steps
involved. Each full commit message contains extensive descriptions,
explanations, and relevant links for that particular migration step.

[Bash]: https://www.gnu.org/software/bash/
[Bazel]: https://bazel.build/
[Bazel modules]: https://bazel.build/external/module
[Bazelisk]: https://github.com/bazelbuild/bazelisk?tab=readme-ov-file#installation
[Bzlmod migration guide]: https://bazel.build/external/migration
[FrobozzCo International]: https://zork.fandom.com/wiki/FrobozzCo_International
[Releases]: https://github.com/EngFlow-Academy/bzlmod-bootcamp/releases
[Visual Studio Code]: https://code.visualstudio.com/
[Vim keybindings]: https://marketplace.visualstudio.com/items?itemName=vscodevim.vim
[WORKSPACE.bzlmod]: https://bazel.build/external/migration#workspace.bzlmod
[Xcode]: https://developer.apple.com/xcode/
[external dependencies]: https://bazel.build/external/overview
[legacy WORKSPACE]: https://bazel.build/external/overview#workspace-shortcomings
[bc-vid]: https://youtu.be/yhRW_Fugm9c
[bc-vid-img]: https://img.youtube.com/vi/yhRW_Fugm9c/hqdefault.jpg
  "Bzlmod Migration Bootcamp v1.0.0 at BazelCon in Atlanta, GA on 2025-11-09"
[bcr-tool]: https://bazel.build/external/migration#migration-tool-how-to-use
[blog]: https://blog.engflow.com/category/bzlmod/
[bootcamp]: ./bootcamp/
[bzlmod-bazel-6]: https://bazel.build/versions/6.5.0/external/overview
[bzlmod-only]: https://blog.bazel.build/2023/12/11/bazel-7-release.html#bzlmod
[clang]: https://clang.llvm.org/
[gcc]: https://gcc.gnu.org/
[git repository]: https://git-scm.com/docs/gitglossary#Documentation/gitglossary.txt-repository
[git-for-windows]: https://gitforwindows.org/
[git]: https://git-scm.com/
[Bazel repositories]: https://bazel.build/concepts/build-ref#repositories
[msvc]: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022
[rolling]: https://bazel.build/release/rolling
[rules_magic]: ./rules_magic/
[rules_scala]: https://github.com/bazel-contrib/rules_scala
[scala-bzlmod]: https://github.com/bazel-contrib/rules_scala/issues/1482
[use_repo_rule]: https://bazel.build/rules/lib/globals/module#use_repo_rule
[workspace-vs-bzlmod]: https://blog.engflow.com/2025/01/16/migrating-to-bazel-modules-aka-bzlmod---module-extensions/#module-extensions
[gitk]: https://git-scm.com/book/en/v2/Appendix-A:-Git-in-Other-Environments-Graphical-Interfaces.html#_gitk_and_git_gui
[tig]: https://jonas.github.io/tig/
