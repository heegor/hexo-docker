FROM alpine:3.8

LABEL maintainer="https://github.com/heegor/hexo-docker"

ARG GIT_USER_NAME
ARG GIT_USER_EMAIL
ARG HEXO_DOCKER_HOME
ARG HEXO_TIMEZONE
ARG USER_ID
ARG USER_HOME


RUN \
    # Run with user `hexo`, uid is the same to the user who builds
    # the image in the host server
    adduser -D -S -h "$USER_HOME" -u $USER_ID -s /bin/sh -g hexo hexo \
    # Install timezone
    && apk add tzdata \
    # Install hexo
    && apk add --no-cache openssh git nodejs nodejs-npm \
    && npm install -g hexo-cli

RUN \
    if [ -f /usr/share/zoneinfo/$HEXO_TIMEZONE ]; \
    then \
        ln -sf /usr/share/zoneinfo/$HEXO_TIMEZONE /etc/localtime \
        && echo $HEXO_TIMEZONE > /etc/timezone; \
    fi;

USER hexo

RUN \
    # Git settings
    git config --global user.name "$GIT_USER_NAME" \
    && git config --global user.email "$GIT_USER_EMAIL"


VOLUME $HEXO_DOCKER_HOME
WORKDIR $HEXO_DOCKER_HOME
EXPOSE 4000

CMD ["/bin/sh"]
