#!/bin/bash

set -e

while read line;do  
    eval "$line"  
done < conf/install.conf

docker exec -it $APP_NAME sh
