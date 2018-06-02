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
    -p $HEXO_PORT:4000 \
    -v $HEXO_HOME:/hexo \
    -v $SSH_HOME:/.ssh \
    --name=$APP_NAME \
    $APP_NAME:$APP_VERSION
