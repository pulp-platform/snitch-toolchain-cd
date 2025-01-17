# Dockerfile for a simple Ubuntu with the Snitch LLVM toolchain

FROM ubuntu:20.04

# Pass this variable to indicate the toolchain tar
ARG TCTAR

LABEL maintainer huettern@ethz.ch

RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y git build-essential git python python3 python3-distutils wget

# The user running
RUN useradd -m -u 1002 builder
USER builder

# Extract toolchain, cleanup and modify path
RUN \
    cd /home/builder && mkdir -p .local/riscv32-pulp-llvm && \
    wget -qO- \
    https://sourceforge.net/projects/pulp-llvm-project/files/nightly/riscv32-pulp-ubuntu2004.tar.gz/download | \
    tar -xvz -C .local/riscv32-pulp-llvm --strip-components 1 && \
    .local/riscv32-pulp-llvm/bin/clang --version && \
    .local/riscv32-pulp-llvm/bin/llvm-config --version

ENV PATH "/home/builder/.local/riscv32-pulp-llvm/bin:${PATH}"

WORKDIR /home/builder
