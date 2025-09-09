"""Implementation of the magic_leaflet rule."""

def _magic_leaflet_impl(ctx):
    text_files = ctx.files.text

    return [DefaultInfo(
        files = depset(text_files),
        runfiles = ctx.runfiles(files = text_files),
    )]

magic_leaflet = rule(
    implementation = _magic_leaflet_impl,
    attrs = {
        "text": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
    },
)
