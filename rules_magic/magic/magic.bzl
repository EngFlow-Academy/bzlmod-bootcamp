"""rules_magic public API"""

load(":magic_digests.bzl", _magic_digests = "magic_digests")
load(":magic_library.bzl", _magic_library = "magic_library")
load(":magic_test.bzl", _magic_test = "magic_test")

magic_digests = _magic_digests
magic_library = _magic_library
magic_test = _magic_test
