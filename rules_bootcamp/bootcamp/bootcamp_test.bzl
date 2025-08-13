"""Bootcamp rules and macros"""

load("@rules_java//java:defs.bzl", "java_test")

_ATTRS = {
    # TODO: Make this configurable by the config repo.
    "test_class": attr.string(),
}

def _bootcamp_library_impl(ctx):
    pass

bootcamp_library = rule(
    implementation = _bootcamp_library_impl,
    attrs = _ATTRS,
    toolchains = ["//bootcamp:toolchain_type"],
)

def bootcamp_test(name, **kwargs):
    lib_name = name + "_bootcamp_library"

    java_test(
        name = name,
        deps = kwargs.pop("deps", []) + [lib_name]
        **kwargs
    )

    bootcamp_library(
        name = lib_name,
    )
