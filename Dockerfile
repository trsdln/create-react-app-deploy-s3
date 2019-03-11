FROM node:carbon-slim

# Install AWS CLI
RUN apt-get update -q \
    && echo "Installing Python 3 & PIP & Git" \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends python3-pip python3-dev python3-setuptools git \
    && echo "Installing AWS CLI" \
    && pip3 install awscli \
    && rm -rf /var/lib/apt/lists/*

# Install and run keybase service
ENV KEYBASE_ALLOW_ROOT 1

RUN apt-get update -q \
    && curl -O https://prerelease.keybase.io/keybase_amd64.deb \
    && dpkg -i keybase_amd64.deb \
    # Ignore an error about missing `libappindicator1`
    # from the previous command, as the
    # subsequent command corrects it
    || $(exit 0) \
    && apt-get install --no-install-recommends -f -y \
    # Cleanup
    && rm -rf /var/lib/apt/lists/* \
    && rm -f keybase_amd64.deb \
    && run_keybase

# Install docker 
RUN apt-get update -q \
    && apt-get install --no-install-recommends -y apt-transport-https ca-certificates \
        gnupg2 software-properties-common \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt-get update -q \
    && apt-get install --no-install-recommends -y docker-ce \
    && rm -rf /var/lib/apt/lists/*

# Install MongoDB (for integration testing)
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 \
    && echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" \ 
      | tee /etc/apt/sources.list.d/mongodb-org-4.0.list \
    && apt-get update -q \
    && apt-get install --no-install-recommends -y mongodb-org-server=4.0.5 \
    && rm -rf /var/lib/apt/lists/*

# Install Kubectl & Helm
RUN curl -LOs https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    curl -LOs https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz && \
    tar -zxvf helm-v2.12.3-linux-amd64.tar.gz >> /dev/null && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm helm-v2.12.3-linux-amd64.tar.gz && rm -rf linux-amd64

# Manages monorepo
RUN yarn global add lerna

# Print yarn version for peace of mind
RUN yarn --version

