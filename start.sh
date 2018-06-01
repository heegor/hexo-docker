#!/bin/bash

# Parse the arguments

while [[ -n "$1" ]]
do
    case $1 in
    -p)
        port="$2"
	shift
        ;;
    -h)
        # Print help message
        echo -e "Usages:"
        echo -e "\t -p <port number> \t\t Specify the port number"
        exit 0
        ;; 
     *)
        echo -e "$1 is not a valid option"
        exit 1
        ;;
    esac
    shift
done

# Port should be provided
if [ -z "$port" ]; then
    port="8888"
fi


# Read config
while read line;do  
    eval "$line"  
done < conf/install.conf 


# remove the old contain if exists
if [ `docker ps -a | grep $APP_NAME -wc` -gt 0 ]; then
    docker stop $APP_NAME
    docker rm $APP_NAME 
fi

# start the new container
work_dir=$(cd `dirname $0`; pwd)

docker run \
    -i \
    -d \
    -p $port:4000 \
    -v $HEXO_HOME:/hexo \
    -v $SSH_HOME:/.ssh \
    --name=$APP_NAME \
    $APP_NAME:$APP_VERSION
