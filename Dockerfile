FROM node:latest

# Install AWS CLI
RUN apt-get update -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy python3-pip python3-dev
RUN pip3 install awscli

# Install latest Meteor
RUN curl https://install.meteor.com | sh

# json is used for parsing configurations
RUN yarn global add json

# Manages monorepo
RUN yarn global add lerna

# Print yarn version for peace of mind
RUN yarn --version
