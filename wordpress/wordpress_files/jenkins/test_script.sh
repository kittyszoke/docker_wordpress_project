#!/bin/bash

cd ..
docker-compose up -d
sleep 30
sudo docker-compose port wordpress_askj 80
if curl localhost:$(docker-compose port wordpress_askj 80 | awk -F: '{print $2}') | grep -i wordpress >/dev/null 2>&1
then
	echo "Success in accessing the web page"
    FAILED=0
else
	echo "FAILED TESTING STAGE"
    FAILED=1
fi

# Publish our working container image (PHP image only)
if ! docker-compose push wordpress_askj >/dev/null 2>&1
then
    echo "FAILED PUBLISH CONTAINER IMAGE"
    FAILED=2
fi

docker-compose down --rmi all -v
exit $FAILED