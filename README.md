# Docker image: elasticsearch-light-testing

A Docker image running Elasticsearch on Fedora, tuned for development only.

TODO: explain why

Recommended startup:

> docker stop es-it && docker rm es-it
> docker run -ti --tmpfs /run --tmpfs=/opt/elasticsearch/volatile/data:uid=1000 --tmpfs --tmpfs=/opt/elasticsearch/volatile/logs:uid=1000 -p 9200:9200 -p 9300:9300 --name es-it sanne/elasticsearch-light-testing

Registered on DockerHub: https://hub.docker.com/r/sanne/elasticsearch-light-testing/ 

Build it locally:

> docker build -t customtest .

Don't forget to change `customtest` consistently in the run script:

> docker run -ti --tmpfs /run --tmpfs=/opt/elasticsearch/volatile/data:uid=1000 --tmpfs --tmpfs=/opt/elasticsearch/volatile/logs:uid=1000 -p 9200:9200 -p 9300:9300 --name es-it customtest


