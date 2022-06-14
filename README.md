## Steps

```
docker build -t prandom .
docker run --privileged --name prandom-docker -d \
    -e DOCKER_TLS_CERTDIR='' \
    prandom
docker exec -it prandom-docker sh
./start.sh
```


