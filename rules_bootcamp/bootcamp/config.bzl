"""Generates the @io_bazel_rules_bootcamp_config repo.

Modeled after @rules_scala//scala_config.bzl.
"""

DEFAULT_BOOTCAMP_VERSION = "1.2.3"

_CONFIG_BUILD = """load("@bazel_skylib//rules:common_settings.bzl", "string_setting")

string_setting(
    name = "bootcamp_version",
    build_setting_default = "{version}",
    values = {versions},
    visibility = ["//visibility:public"],
)

"""

_CONFIG_SETTING = """config_setting(
    name = "bootcamp_version_{suffix}",
    flag_values = {{":bootcamp_version": "{version}"}},
    visibility = ["//visibility:public"],
)
"""

def _build_file_content(version, versions):
    version_suffix = version.replace(".", "_")
    return (
        _CONFIG_BUILD.format(version = version, versions = versions)
        + "\n".join([
            _CONFIG_SETTING.format(version = v, suffix = version_suffix)
            for v in versions
        ])
        + "\n"
    )

def _config_file_content(version, versions, enable_some_feature):
    return "\n".join([
        "BOOTCAMP_VERSION = \"" + version + "\"",
        "BOOTCAMP_VERSIONS = " + str(versions),
        "ENABLE_SOME_FEATURE = " + enable_some_feature,
    ]) + "\n"

def _store_config(repository_ctx):
    rctx_env = repository_ctx.os.environ
    rctx_attr = repository_ctx.attr

    # Default version
    version = rctx_env.get("BOOTCAMP_VERSION", rctx_attr.version)
    enable_some_feature = rctx_env.get(
        "ENABLE_SOME_FEATURE",
        str(rctx_attr.enable_some_feature),
    )

    versions = rctx_attr.versions
    if not versions:
        versions = [version]
    elif version not in versions:
        fail(
            "You have to include the default bootcamp version " +
            "(%s) in the `bootcamp_versions` list." % version
        )

    repository_ctx.file("BUILD", _build_file_content(version, versions))
    repository_ctx.file(
        "config.bzl",
        _config_file_content(
            version,
            versions,
            enable_some_feature,
        ),
    )

_config_repository = repository_rule(
    implementation = _store_config,
    doc = "rules_bootcamp configuration parameters",
    attrs = {
        "version": attr.string(
            mandatory = True,
            doc = "Default Bootcamp version",
        ),
        "versions": attr.string_list(
            mandatory = True,
            doc = (
                "List of all Bootcamp versions to configure. " +
                "Must include the default version."
            ),
        ),
        "enable_some_feature": attr.bool(
            default = False,
            doc = "Boolean to enable or disable some feature",
        ),
    },
    environ = ["BOOTCAMP_VERSION", "ENABLE_SOME_FEATURE"],
)

def bootcamp_config(
        version = DEFAULT_BOOTCAMP_VERSION,
        versions = [],
        enable_some_feature = False):
    _config_repository(
        name = "io_frobozzco_rules_bootcamp_config",
        version = version,
        versions = versions,
        enable_some_feature = enable_some_feature,
    )
