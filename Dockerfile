FROM node:carbon-slim

# Install and run keybase service
ENV KEYBASE_ALLOW_ROOT 1

RUN curl -O https://prerelease.keybase.io/keybase_amd64.deb \
    && dpkg -i keybase_amd64.deb \
    # Ignore an error about missing `libappindicator1`
    # from the previous command, as the
    # subsequent command corrects it
    || $(exit 0) \
    && apt-get install -f -y \
    && run_keybase

