#! /bin/bash
RCol='\e[0m' ; Red='\e[0;31m'; Yel='\e[0;33m'; Blu='\e[0;34m'; Gre='\e[0;32m'; Pur='\e[0;35m'; Cya='\e[0;36m';
IMAGE="yohangz/ornamentum"
CONTAINER="ornamentum-container"

function print() {
        echo -e "\n$2$1$RCol"
}

function handleError() {
        if [ "$1" == "0" ]
        then
                echo -e "\n$Gre$2$RCol"
        else
                echo -e "\n$Red$3$RCol"
                exit 1
        fi
}

print "Deploy start" "$Gre"
if docker ps -a | grep -q "$CONTAINER"
then
        print "Container '$CONTAINER' found" "$Gre"
        docker stop "$CONTAINER"
        handleError "$?" "Container stop successful" "Container stop failure"

        docker rm "$CONTAINER"
        handleError "$?" "Container remove successful" "Container remove failure"
else
        print "Container '$CONTAINER' not found" "$Gre"
fi

docker images -a |  grep -q "$IMAGE"
if [ "$1" == "0" ]
then
        docker rmi "$IMAGE"
        handleError "$?" "Image removed" "Image remove failure"
fi

docker pull "$IMAGE"
handleError "$?" "Image pull successful" "Image pull failure"

docker run --name "$CONTAINER" --restart unless-stopped -p 8080:8080 -d "$IMAGE"
handleError "$?" "Docker run successful" "Container run failure"

print "Docker image list" "$Gre"
docker images

print "Docker process list" "$Gre"
docker ps

print "Deploy end" "$Gre"
