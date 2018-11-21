FROM node:carbon

# Install AWS CLI
RUN apt-get update -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy python3-pip python3-dev
RUN pip3 install awscli

# Install and run keybase service
ENV KEYBASE_ALLOW_ROOT 1

RUN curl -O https://prerelease.keybase.io/keybase_amd64.deb \
    && dpkg -i keybase_amd64.deb \
    # Ignore an error about missing `libappindicator1`
    # from the previous command, as the
    # subsequent command corrects it
    || $(exit 0) \
    && apt-get install -f -y \
    # Cleanup
    && rm -rf /var/lib/apt/lists/* \
    && rm -f keybase_amd64.deb

RUN run_keybase

# Install latest Meteor
RUN curl https://install.meteor.com | sh

# json is used for parsing configurations
RUN yarn global add json

# Manages monorepo
RUN yarn global add lerna

# Print yarn version for peace of mind
RUN yarn --version
