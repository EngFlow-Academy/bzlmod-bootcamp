load(
    "//magic:private/leaflet_repo.bzl",
    _magic_leaflet_repo = "magic_leaflet_repo",
)

# Replace with an assignment from _magic_leaflet_repo once all supported
# Bazels have repository_ctx.original_name.
def rules_magic_leaflet_repo(**kwargs):
    name = kwargs.pop("name", "rules_magic_leaflet")

    _magic_leaflet_repo(
        name = name,
        default_target_name = kwargs.pop("default_target_name", name),
        **kwargs
    )
