#!/bin/bash

set -e

# Read config
echo "Reading configuraiton file"

while read line;do  
    eval "$line"  
done < conf/install.conf

# Build docker image
echo "Building image"

docker build \
    -t $APP_NAME:$APP_VERSION \
    --build-arg GIT_USER_NAME="$GIT_USER_NAME" \
    --build-arg GIT_USER_EMAIL="$GIT_USER_EMAIL" \
    --build-arg HEXO_DOCKER_HOME="$HEXO_DOCKER_HOME" \
    .

# Remove the old container if exists
if [ `docker ps -a | grep $APP_NAME -wc` -gt 0 ]; then
    echo "Removing old service"

    docker stop $APP_NAME
    docker rm $APP_NAME 
fi

# Start the new container
echo "Initializing new service"

work_dir=$(cd `dirname $0`; pwd)

docker create \
    -i \
    -p $HEXO_LOCAL_PORT:4000 \
    -v $HEXO_LOCAL_HOME:$HEXO_DOCKER_HOME \
    -v $SSH_LOCAL_HOME:/root/.ssh \
    --name=$APP_NAME \
    $APP_NAME:$APP_VERSION
