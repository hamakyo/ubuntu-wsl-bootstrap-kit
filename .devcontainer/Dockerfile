FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      curl \
      git \
      make \
      python3 \
      python3-pip \
      nodejs \
      npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER vscode
