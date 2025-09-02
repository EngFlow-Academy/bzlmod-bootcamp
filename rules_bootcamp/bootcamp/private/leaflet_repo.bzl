"""Defines the repository rule for @io_frobozzco_rules_bootcamp_leaflet."""

_LEAFLET_CONTENT = """\
In the interest of avoiding a potential copyright violation, please search for
"read leaflet" in the following document and read the contents from there:

https://web.mit.edu/marleigh/www/portfolio/Files/zork/transcript.html
"""

_BUILD_CONTENT = """\
alias(
    name = "%s",
    actual = "leaflet.txt",
    visibility = ["//visibility:public"],
)
"""

def _bootcamp_leaflet_repo_impl(rctx):
    rctx.file("leaflet.txt", _LEAFLET_CONTENT, executable = False)
    rctx.file("BUILD", _BUILD_CONTENT % rctx.name, executable = False)

bootcamp_leaflet_repo = repository_rule(
    implementation = _bootcamp_leaflet_repo_impl,
)
