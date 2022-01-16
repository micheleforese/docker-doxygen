# Dockerfile for Doxygen

## Doxygen

```sh
docker run --rm -v "$(pwd -W)":/src -it test/doxygen doxygen
```

## Building the Image

```sh
docker build \
-t test/doxygen:latest \
-t test/doxygen:v1 \
-t test/doxygen:v1.9 \
-t test/doxygen:v1.9.2 \
.
```
