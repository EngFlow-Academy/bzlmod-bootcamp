"""Module extension to generate the @rules_magic_config repo.

Modeled after @rules_scala//scala/extensions/config.bzl.
"""

load(
    "//magic:config.bzl",
    "DEFAULT_MAGIC_VERSION",
    _magic_config = "magic_config",
)
load("//magic/extensions:private/bzlmod.bzl", "root_module_settings")

_settings_defaults = {
    "version": DEFAULT_MAGIC_VERSION,
    "versions": [],
    "enable_some_feature": False,
}

_settings_attrs = {
    "version": attr.string(
        default = _settings_defaults["version"],
        doc = (
            "magic version used by the default toolchain. " +
            "Overridden by the `MAGIC_VERSION` environment variable."
        ),
    ),
    "versions": attr.string_list(
        default = _settings_defaults["versions"],
        doc = "Other magic versions used in the build",
    ),
    "enable_some_feature": attr.bool(
        default = _settings_defaults["enable_some_feature"],
        doc = (
            "Enables some `rules_magic` feature. " +
            "Overridden by the `ENABLE_SOME_FEATURE` environment variable."
        ),
    ),
}

_tag_classes = {
    "settings": tag_class(
        attrs = _settings_attrs,
        doc = "`rules_magic` configuration parameters",
    ),
}

def _magic_config_impl(module_ctx):
    settings = root_module_settings(module_ctx, _settings_defaults)

    menv = module_ctx.os.environ
    version = menv.get("MAGIC_VERSION", settings["version"])

    _magic_config(
        version = version,
        versions = settings["versions"] or [version],
        enable_some_feature = menv.get(
            "ENABLE_SOME_FEATURE",
            settings["enable_some_feature"],
        ),
    )

magic_config = module_extension(
    implementation = _magic_config_impl,
    tag_classes = _tag_classes,
    environ = ["MAGIC_VERSION", "ENABLE_SOME_FEATURE"],
    doc = (
        "Configures core `rules_scala` parameters and exports them via the " +
        "`@rules_scala_config` repository"
    ),
)
