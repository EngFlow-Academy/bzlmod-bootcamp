"""Implementation of the bootcamp_leaflet rule."""

def _bootcamp_leaflet_impl(ctx):
    text_files = ctx.files.text

    return [DefaultInfo(
        files = depset(text_files),
        runfiles = ctx.runfiles(files = text_files),
    )]

bootcamp_leaflet = rule(
    implementation = _bootcamp_leaflet_impl,
    attrs = {
        "text": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
    },
)
