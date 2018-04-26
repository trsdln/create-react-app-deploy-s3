FROM node:latest

# install AWS CLI
RUN apt-get update -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy python3-pip python3-dev
# python-pip groff-base
RUN pip3 install awscli
