"""Helper functions for implementing module extensions"""

def root_module_settings(mctx, defaults):
    """Return root module's `settings` tag values or their default values.

    Args:
        mctx: the module extension's module_ctx object
        defaults: a dictionary of default values for the settings tag class

    Returns:
        the values from the root module's first `settings` tag, or `defaults`
    """
    for mod in mctx.modules:
        if mod.is_root:
            # For simplicitly, only read the one tag. See `rules_scala`'s
            # scala/extensions/config.bzl and scala/private/macros/bzlmod.bzl
            # for an example using more robust macros.
            return {k: getattr(mod.tags.settings[0], k) for k in defaults}
    return defaults
