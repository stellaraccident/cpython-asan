from setuptools import setup, Extension

asan = Extension(
    "asan",
    ["asan.c"],
    language="c",
)

setup(name="asan-test", ext_modules=[asan])
