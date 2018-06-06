FROM alpine:3.7

LABEL maintainer="https://github.com/heegor/hexo-docker"

ARG GIT_USER_NAME
ARG GIT_USER_EMAIL
ARG HEXO_DOCKER_HOME
ARG USER_ID


RUN \
    # Run with user `hexo`, uid is the same to the user who builds
    # the image in the host server
    adduser -D -S -h $HEXO_DOCKER_HOME -u $USER_ID -s /bin/sh hexo \
    # Installations and configurations
    && apk add --no-cache openssh git nodejs nodejs-npm \
    && npm install -g hexo-cli \
    # Git settings
    && git config --global user.name "$GIT_USER_NAME" \
    && git config --global user.email "$GIT_USER_EMAIL"


USER hexo

CMD ["/bin/sh"]
