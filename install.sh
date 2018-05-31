#!/bin/bash

# Read config
while read line;do  
    eval "$line"  
done < conf/install.conf

docker build -t $APP_NAME:$APP_VERSION .
