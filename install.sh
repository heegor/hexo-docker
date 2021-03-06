#!/bin/bash

set -e

# Read config
echo "Reading configuraiton file"

while read line;do  
    eval "$line"  
done < conf/install.conf

# create directory if necessary
if [ ! -d $HEXO_LOCAL_HOME ]; then
    mkdir -p $HEXO_LOCAL_HOME
fi

# Build docker image
echo "Building image"

user_id=`id -u`
user_home="/home/hexo"

docker build \
    -t $APP_NAME:$APP_VERSION \
    --build-arg GIT_USER_NAME="$GIT_USER_NAME" \
    --build-arg GIT_USER_EMAIL="$GIT_USER_EMAIL" \
    --build-arg HEXO_DOCKER_HOME="$HEXO_DOCKER_HOME" \
    --build-arg HEXO_TIMEZONE="$HEXO_TIMEZONE" \
    --build-arg USER_ID=$user_id \
    --build-arg USER_HOME=$user_home \
    .

# Remove the old container if exists
if [ `docker ps -a | grep $APP_NAME -wc` -gt 0 ]; then
    echo "Removing old service"

    docker stop $APP_NAME
    docker rm $APP_NAME 
fi

# Start the new container
echo "Initializing new service"

docker create \
    -i \
    -u $user_id \
    -p $HEXO_LOCAL_PORT:4000 \
    -v $HEXO_LOCAL_HOME:$HEXO_DOCKER_HOME \
    -v $SSH_LOCAL_HOME:$user_home/.ssh \
    --name=$APP_NAME \
    $APP_NAME:$APP_VERSION
