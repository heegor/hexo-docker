#!/bin/bash

set -e

function printHelpMessage {
    echo "Usage: init.sh command"
    echo
    echo -e "Options"
    echo -e "  -m \t Mode. Required, valid values:"
    echo -e "     \t       0 - initialize a clean hexo workspace"
    echo -e "     \t       1 - initialize hexo workspace from a git repository"
    echo
    echo
}

function printErrorMessage {
    echo -e "\033[0;31m$1\033[0m"
    echo
}


# parse the arguments
while [ -n "$1" ]
do
    case $1 in
    -m) 
        # translate the argument value
        if [ $2 -eq 0 ]; then
            mode="HEXO"
        elif [ $2 -eq 1 ]; then
            mode="GIT"
        else
            printErrorMessage "$2 is not a valid value"
            printHelpMessage
            exit 1
        fi

        shift
        ;;
    *)
        printErrorMessage "$1 is not a valid option"
        printHelpMessage
        exit 1
        ;;
    esac
    shift
done

if [ -z $mode ]; then
    printErrorMessage "Missing mode argument"
    printHelpMessage
    exit 1
fi

# reading the configurations
while read line;do  
    eval "$line"  
done < conf/install.conf

while read line;do  
    eval "$line"  
done < conf/hexo.conf


blogDir=$HEXO_LOCAL_HOME/$BLOG_NAME
if [ -d $blogDir ]; then
    printErrorMessage "Blog folder already exists"
    exit 1
fi

if [ "$mode" = "HEXO" ]; then
    # initialize a clean hexo workspace"
    docker exec -t $APP_NAME sh -c "cd $HEXO_DOCKER_HOME && hexo init $BLOG_NAME"
    docker exec -t $APP_NAME sh -c "cd $HEXO_DOCKER_HOME/$BLOG_NAME && npm install hexo-deployer-git --save"
elif [ "$mode" = "GIT" ]; then
    # validate the configuration
    if [ -z "$WORKSPACE_GIT_REPO_URL" ]; then
        printErrorMessage "WORKSPACE_GIT_REPO_URL config is not set"
        exit 1
    fi

    if [ -z "$WORKSPACE_GIT_REPO_BRANCH" ]; then
        printErrorMessage "WORKSPACE_GIT_REPO_BRANCH config is not set"
        exit 1
    fi

    # initialize hexo workspace from a git repository
    echo "Checking out hexo workspace from $WORKSPACE_GIT_REPO_BRANCH"
    docker exec -t $APP_NAME sh -c "cd $HEXO_DOCKER_HOME && git clone -b $WORKSPACE_GIT_REPO_BRANCH $WORKSPACE_GIT_REPO_URL $BLOG_NAME"
    
    echo
    echo "Installing npm packages via existing configurations"
    docker exec -t $APP_NAME sh -c "cd $HEXO_DOCKER_HOME/$BLOG_NAME && npm install"
fi

