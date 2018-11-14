# smaller size but doesn't support Meteor
FROM node:carbon-alpine

# Install AWS CLI
RUN apk -v --update add \
        python \
        py-pip \
        groff \
        less \
        mailcap \
        && \
    pip install --upgrade awscli==1.14.5 s3cmd==2.0.1 python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

# json is used for parsing configurations
RUN yarn global add json

# Manages monorepo
RUN yarn global add lerna

# Print yarn version for peace of mind
RUN yarn --version
