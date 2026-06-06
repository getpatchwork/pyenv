FROM python:3.11-slim AS py311
FROM python:3.12-slim AS py312
FROM python:3.13-slim AS py313
FROM python:3.14-slim AS py314

FROM debian:bookworm-slim

LABEL org.opencontainers.image.title="pyenv (Patchwork development)"
LABEL org.opencontainers.image.description="pyenv container for use in Patchwork development and CI"
LABEL org.opencontainers.image.source="https://github.com/getpatchwork/pyenv"
LABEL org.opencontainers.image.documentation="https://patchwork.readthedocs.io/en/latest/"
LABEL org.opencontainers.image.licenses=GPL

ENV LANG="C.UTF-8"
ENV LC_ALL="C.UTF-8"
ENV PATH="/usr/local/bin:$PATH"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update --quiet && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        libbz2-1.0 \
        libffi8 \
        libsqlite3-0 \
        libssl3 \
        zlib1g && \
    rm -rf /var/lib/apt/lists/*

COPY --from=py311 /usr/local/bin/python3.11 /usr/local/bin/
COPY --from=py311 /usr/local/bin/pip3.11 /usr/local/bin/
COPY --from=py311 /usr/local/lib/python3.11 /usr/local/lib/python3.11
COPY --from=py311 /usr/local/lib/libpython3.11.so.1.0 /usr/local/lib/

COPY --from=py312 /usr/local/bin/python3.12 /usr/local/bin/
COPY --from=py312 /usr/local/bin/pip3.12 /usr/local/bin/
COPY --from=py312 /usr/local/lib/python3.12 /usr/local/lib/python3.12
COPY --from=py312 /usr/local/lib/libpython3.12.so.1.0 /usr/local/lib/

COPY --from=py313 /usr/local/bin/python3.13 /usr/local/bin/
COPY --from=py313 /usr/local/bin/pip3.13 /usr/local/bin/
COPY --from=py313 /usr/local/lib/python3.13 /usr/local/lib/python3.13
COPY --from=py313 /usr/local/lib/libpython3.13.so.1.0 /usr/local/lib/

COPY --from=py314 /usr/local/bin/python3.14 /usr/local/bin/
COPY --from=py314 /usr/local/bin/pip3.14 /usr/local/bin/
COPY --from=py314 /usr/local/lib/python3.14 /usr/local/lib/python3.14
COPY --from=py314 /usr/local/lib/libpython3.14.so.1.0 /usr/local/lib/

RUN ldconfig && \
    ln -s python3.14 /usr/local/bin/python3 && \
    ln -s python3.14 /usr/local/bin/python && \
    ln -s pip3.14 /usr/local/bin/pip3 && \
    ln -s pip3.14 /usr/local/bin/pip
