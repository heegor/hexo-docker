#!/bin/bash

set -e

while read line;do  
    eval "$line"  
done < conf/install.conf

while read line;do  
    eval "$line"  
done < conf/hexo.conf

docker exec -t $APP_NAME sh -c "cd $HEXO_DOCKER_HOME && hexo init $DEFAULT_BLOG_NAME"
