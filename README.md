# Silly little repo for building an ASAN cpython

There's not much here. Largely it is just a place I can stash
a script and some stuff so I don't forget how to build a
python interpreter that is ASAN enabled.

## Setup

```
# Will sudo apt some stuff
./ububunto-deps.sh
```

## Build

```
./build.sh
```

Some environment variables that it may be useful to source in
dependent projects are output to `env`.

Python is installed into `install/`.

## Test

You can verify that extensions will build with asan by default
and trigger asan failures by runnint `./test-asan.sh`.

This builds an `asan` extension and triggers it.
