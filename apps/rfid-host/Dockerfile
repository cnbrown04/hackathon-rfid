# syntax=docker/dockerfile:1.7

FROM --platform=linux/amd64 ubuntu:22.04 AS builder

WORKDIR /app

ARG ZIG_VERSION=0.14.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      libpq-dev \
      libxml2-dev \
      pkg-config \
      wget \
      xz-utils && \
    wget -qO- "https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz" | tar -xJ -C /opt && \
    ln -s "/opt/zig-linux-x86_64-${ZIG_VERSION}/zig" /usr/local/bin/zig && \
    rm -rf /var/lib/apt/lists/*

COPY build.zig ./
COPY src ./src
COPY linux64_sdk ./linux64_sdk

RUN zig build -Doptimize=ReleaseSafe

FROM --platform=linux/amd64 ubuntu:22.04 AS runtime

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      libpq5 \
      libstdc++6 \
      libxml2 && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/zig-out/bin/rfid_queue_host /app/rfid_queue_host
COPY --from=builder /app/linux64_sdk /app/linux64_sdk

ENV LD_LIBRARY_PATH=/app/linux64_sdk/lib

ENTRYPOINT ["/app/rfid_queue_host"]
