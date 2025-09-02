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
    # Replace with rctx.original_name once all supported Bazels have it.
    repo_name = getattr(rctx, "original_name", rctx.attr.default_target_name)

    rctx.file("leaflet.txt", _LEAFLET_CONTENT, executable = False)
    rctx.file(
        "BUILD",
        _BUILD_CONTENT.format(
            rules_magic_repo = _RULES_MAGIC_REPO,
            leaflet_name = repo_name,
        ),
        executable = False,
    )

magic_leaflet_repo = repository_rule(
    implementation = _magic_leaflet_repo_impl,
    attrs = {
        # Remove once all supported Bazels have repository_ctx.original_name.
        "default_target_name": attr.string(mandatory = True),
    }
)
