#!/bin/bash

set -e

while read line;do  
    eval "$line"  
done < conf/install.conf

docker start $APP_NAME
