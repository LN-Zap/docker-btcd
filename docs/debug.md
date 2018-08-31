# Debugging

## Viewing btcd Logs

    docker logs btcd-node

## Running Bash in Docker Container

_Note:_ This container will be run in the same way as the btcd node, but will not connect to already running containers or processes.

    docker run -v btcd-data:/btcd --rm -it lnzap/btcd bash -l

You can also attach bash into running container to debug running btcd

    docker exec -it btcd-node bash -l
