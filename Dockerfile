FROM node:carbon-slim

# Install AWS CLI
RUN apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends python3-pip python3-dev \
    && pip3 install awscli \
    && rm -rf /var/lib/apt/lists/*

# Install and run keybase service
ENV KEYBASE_ALLOW_ROOT 1

RUN curl -O https://prerelease.keybase.io/keybase_amd64.deb \
    && dpkg -i keybase_amd64.deb \
    # Ignore an error about missing `libappindicator1`
    # from the previous command, as the
    # subsequent command corrects it
    || $(exit 0) \
    && apt-get install --no-install-recommends -f -y \
    # Cleanup
    && apt-get remove curl \
    && apt autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f keybase_amd64.deb \
    && run_keybase

# Manages monorepo
RUN yarn global add lerna

# Print yarn version for peace of mind
RUN yarn --version
