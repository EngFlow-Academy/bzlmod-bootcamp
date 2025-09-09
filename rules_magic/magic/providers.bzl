"""https://bazel.build/extending/rules#providers"""

MagicInfo = provider(
    "Configured values for the rules_magic toolchain",
    fields = {
        "version": "string identifying the rules_magic version",
        "versions": "strings identifying all valid rules_magic versions",
        "some_feature": "boolean indicating enablement of some_feature",
    },
)
