"""Generates the @io_bazel_rules_bootcamp_config repo.

Modeled after @rules_bootcamp//bootcamp_config.bzl.
"""

DEFAULT_BOOTCAMP_VERSION = "1.2.3"

def _config_setting(bootcamp_version):
    return """config_setting(
    name = "bootcamp_version{version_suffix}",
    flag_values = {{":bootcamp_version": "{version}"}},
    visibility = ["//visibility:public"],
)
""".format(version_suffix = version_suffix(bootcamp_version), version = bootcamp_version)

def _config_settings(bootcamp_versions):
    return "".join([_config_setting(v) for v in bootcamp_versions])

def _store_config(repository_ctx):
    # Default version
    bootcamp_version = repository_ctx.os.environ.get(
        "BOOTCAMP_VERSION",
        repository_ctx.attr.bootcamp_version,
    )

    bootcamp_versions = repository_ctx.attr.bootcamp_versions
    if not bootcamp_versions:
        bootcamp_versions = [bootcamp_version]
    elif bootcamp_version not in bootcamp_versions:
        fail(
            "You have to include the default bootcamp version " +
            "(%s) in the `bootcamp_versions` list." % bootcamp_version
        )

    enable_dependency_tracking = repository_ctx.os.environ.get(
        "ENABLE_DEPENDENCY_TRACKING",
        str(repository_ctx.attr.enable_compiler_dependency_tracking),
    )

    config_file_content = "\n".join([
        "BOOTCAMP_VERSION='" + bootcamp_version + "'",
        "BOOTCAMP_VERSIONS=" + str(bootcamp_versions),
        "ENABLE_DEPENDENCY_TRACKING=" + enable_dependency_tracking,
    ])

    build_file_content = """load("@bazel_skylib//rules:common_settings.bzl", "string_setting")
string_setting(
    name = "bootcamp_version",
    build_setting_default = "{bootcamp_version}",
    values = {bootcamp_versions},
    visibility = ["//visibility:public"],
)
""".format(
    bootcamp_version = bootcamp_version,
    bootcamp_versions = bootcamp_versions,
)
    build_file_content += _config_settings(bootcamp_versions)

    repository_ctx.file("config.bzl", config_file_content)
    repository_ctx.file("BUILD", build_file_content)

_config_repository = repository_rule(
    implementation = _store_config,
    doc = "rules_bootcamp configuration parameters",
    attrs = {
        "bootcamp_version": attr.string(
            mandatory = True,
            doc = "Default Bootcamp version",
        ),
        "bootcamp_versions": attr.string_list(
            mandatory = True,
            doc = (
                "List of all Bootcamp versions to configure. " +
                "Must include the default version."
            ),
        ),
        "enable_dependency_tracking": attr.bool(
            mandatory = True,
        ),
    },
    environ = ["BOOTCAMP_VERSION", "ENABLE_DEPENDENCY_TRACKING"],
)

def bootcamp_config(
        bootcamp_version = DEFAULT_BOOTCAMP_VERSION,
        bootcamp_versions = [],
        enable_compiler_dependency_tracking = False):
    _config_repository(
        name = "rules_bootcamp_config",
        bootcamp_version = bootcamp_version,
        bootcamp_versions = bootcamp_versions,
        enable_compiler_dependency_tracking = enable_compiler_dependency_tracking,
    )
