"""Client-side module extension for @rules_magic_config"""

load(
    "@rules_magic//magic:config.bzl",
    "DEFAULT_MAGIC_VERSION",
    _magic_config = "magic_config",
)

_settings_attrs = {
    "version": attr.string(
        default = DEFAULT_MAGIC_VERSION,
        doc = "magic version used by the default toolchain",
    ),
    "versions": attr.string_list(
        doc = "Other magic versions used in the build",
    ),
    "enable_some_feature": attr.bool(
        default = False,
        doc = "Enables some `rules_magic` feature",
    ),
}

_tag_classes = {
    "settings": tag_class(
        attrs = _settings_attrs,
        doc = "`rules_magic` configuration parameters",
    ),
}

def _magic_config_impl(module_ctx):
    for mod in module_ctx.modules:
        if mod.is_root:
            # This module is by definition the root module.
            settings = mod.tags.settings[0]
            _magic_config(
                version = settings.version,
                versions = settings.versions,
                enable_some_feature = settings.enable_some_feature,
            )
            break


magic_config = module_extension(
    implementation = _magic_config_impl,
    tag_classes = _tag_classes,
    doc = (
        "Configures core `rules_scala` parameters and exports them via the " +
        "`@rules_scala_config` repository"
    ),
)
