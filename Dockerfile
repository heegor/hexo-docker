FROM alpine:3.7

LABEL maintainer="https://github.com/heegor/hexo-docker"

RUN apk add --no-cache git nodejs nodejs-npm \
    && npm install -g hexo-cli
 
CMD ["/bin/sh"]
