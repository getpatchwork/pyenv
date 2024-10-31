FROM ubuntu:24.04 AS base

LABEL org.opencontainers.image.title="pyenv (Patchwork development)"
LABEL org.opencontainers.image.description="pyenv container for use in Patchwork development and CI"
LABEL org.opencontainers.image.source="https://github.com/getpatchwork/pyenv"
LABEL org.opencontainers.image.documentation="https://patchwork.readthedocs.io/en/latest/"
LABEL org.opencontainers.image.licenses=GPL

ENV LANG="C.UTF-8"
ENV LC_ALL="C.UTF-8"
ENV PATH="/opt/pyenv/shims:/opt/pyenv/bin:$PATH"
ENV PYENV_ROOT="/opt/pyenv"
ENV PYENV_SHELL="bash"
ENV DEBIAN_FRONTEND=noninteractive

# runtime dependencies
RUN apt-get update --quiet && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        git \
        libbz2-1.0 \
        libffi8 \
        #libncursesw5 \
        libreadline8 \
        libsqlite3-0 \
        libssl3 \
        #libxml2 \
        #libxmlsec1 \
        liblzma5 \
        #tk \
        xz-utils \
        zlib1g

RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash && \
    git clone https://github.com/momo-lab/xxenv-latest $PYENV_ROOT/plugins/xxenv-latest && \
    pyenv update

# ---

FROM base AS build

# builder dependencies
RUN apt-get update --quiet && \
    apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libbz2-dev \
        libffi-dev \
        liblzma-dev \
        #libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        #libxml2-dev \
        #libxmlsec1-dev \
        #tk-dev \
        xz-utils \
        zlib1g-dev

RUN pyenv install 3.9 && \
    pyenv install 3.10 && \
    pyenv install 3.11 && \
    pyenv install 3.12 && \
    pyenv install 3.13 && \
    pyenv global $(pyenv versions --bare | tac) && \
    pyenv versions && \
    find ${PYENV_ROOT}/versions -depth \
        \( \
            \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
            -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name '*.a' \) \) \
            -o \( -type f -a -name 'wininst-*.exe' \) \
        \) -exec rm -rf '{}' +

# ---

FROM base

COPY --from=build ${PYENV_ROOT}/versions/ ${PYENV_ROOT}/versions/

RUN pyenv rehash && \
    pyenv global $(pyenv versions --bare | tac) && \
    pyenv versions
