"""https://bazel.build/extending/rules#providers"""

BootcampInfo = provider(
    "Configured values for the rules_bootcamp toolchain",
    fields = {
        "version": "string identifying the rules_bootstrap version",
        "versions": "strings identifying all valid rules_bootstrap versions",
        "some_feature": "boolean indicating enablement of some_feature",
    },
)
