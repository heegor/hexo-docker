#!/bin/bash

set -e

while read line;do  
    eval "$line"  
done < conf/install.conf

# create directory if necessary
if [ ! -d $HEXO_LOCAL_HOME ]; then
    mkdir -p $HEXO_LOCAL_HOME
fi

docker start $APP_NAME
