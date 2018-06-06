FROM alpine:3.7

LABEL maintainer="https://github.com/heegor/hexo-docker"

ARG GIT_USER_NAME
ARG GIT_USER_EMAIL
ARG HEXO_DOCKER_HOME

WORKDIR $HEXO_DOCKER_HOME

RUN apk add --no-cache git nodejs nodejs-npm \
    && npm install -g hexo-cli \
    && npm install hexo-deployer-git --save \
    && git config --global user.name "$GIT_USER_NAME" \
    && git config --global user.email "$GIT_USER_EMAIL"
 
CMD ["/bin/sh"]
