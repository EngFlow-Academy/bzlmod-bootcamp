"""Defines the repository rule for @rules_magic_leaflet."""

_LEAFLET_CONTENT = """\
In the interest of avoiding a potential copyright violation, please search for
"read leaflet" in the following document and read the contents from there:

https://web.mit.edu/marleigh/www/portfolio/Files/zork/transcript.html
"""

_BUILD_CONTENT = """\
load(
    "@@{rules_magic_repo}//magic:private/magic_leaflet.bzl",
    "magic_leaflet",
)

magic_leaflet(
    name = "{leaflet_name}",
    text = "leaflet.txt",
    visibility = ["//visibility:public"],
)
"""

_RULES_MAGIC_REPO = Label("//:all").repo_name

def _magic_leaflet_repo_impl(rctx):
    rctx.file("leaflet.txt", _LEAFLET_CONTENT, executable = False)
    rctx.file(
        "BUILD",
        _BUILD_CONTENT.format(
            rules_magic_repo = _RULES_MAGIC_REPO,
            leaflet_name = rctx.name,
        ),
        executable = False,
    )

magic_leaflet_repo = repository_rule(
    implementation = _magic_leaflet_repo_impl,
)
