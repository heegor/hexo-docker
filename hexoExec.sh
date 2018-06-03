#!/bin/bash

set -e

if [ $# -lt 1 ]; then
    echo "No parameters provided."
    exit 1
fi

# Reading configrations
while read line;do  
    eval "$line"  
done < conf/install.conf

while read line;do  
    eval "$line"  
done < conf/hexo.conf


docker exec $APP_NAME sh -c "cd $HEXO_DOCKER_HOME/$DEFAULT_BLOG_NAME && hexo $@"
