#!/bin/bash

# Read config
while read line;do  
    eval "$line"  
done < conf/install.conf


docker build \
    -t $APP_NAME:$APP_VERSION \
    --build-arg GIT_USER_NAME="$GIT_USER_NAME" \
    --build-arg GIT_USER_EMAIL="$GIT_USER_EMAIL" \
    .
