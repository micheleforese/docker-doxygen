# FIRST Stage - Building the binaries
FROM debian:11 AS build

LABEL mantainer="Michele Forese"

ARG DOXYGEN_SOURCE_TAG=Release_1_9_0
ARG SPHINX_SOURCE_BRANCH=4.x
ARG GRAPHVIZ_SOURCE_TAG=stable_release_2.44.0

CMD ["/bin/sh"]

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    python3.9 \
    python3-pip \
    g++ \
    build-essential \
    flex \
    bison \
    cmake \
    graphviz \
  && rm -rf /var/lib/apt/lists/*

# Create the folders for the installations
RUN mkdir -p /tmp

# Installing Doxygen
RUN cd /tmp \
  && git clone https://github.com/doxygen/doxygen.git \
  && cd doxygen \
  && git checkout tags/$DOXYGEN_SOURCE_TAG -b "v$DOXYGEN_SOURCE_TAG" \
  && mkdir build \
  && cd build \
  && cmake -D CMAKE_CXX_COMPILER="/usr/bin/g++" -G "Unix Makefiles" .. \
  && make \
  && make install

# Installing Sphinx
RUN cd /tmp \
  && git clone https://github.com/sphinx-doc/sphinx.git \
  && cd sphinx \
  && git checkout $SPHINX_SOURCE_BRANCH \
  && pip install .

RUN pip install sphinx_rtd_theme breathe sphinx-sitemap


# SECOND Stage
FROM alpine:3
RUN apk add --no-cache graphviz
COPY --from=build /tmp/doxygen/doxygen /cfg/doxygen

RUN mkdir -p /src

WORKDIR /src

VOLUME [ "/src" ]
