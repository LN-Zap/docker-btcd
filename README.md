# btcd for Docker

Docker image that runs btcd in a container for easy deployment.

The image contains the latest [btcd](https://github.com/btcsuite/btcd) daemon.

## Quick Start

1.  Create a `btcd-data` volume to persist the btcd blockchain data, should exit immediately. The `btcd-data` container will store the blockchain when the node container is recreated (software upgrade, reboot, etc):

        docker volume create --name=btcd-data
        docker run -v btcd-data:/btcd --name=btcd-node -d \
            -p 8333:8333 \
            -p 127.0.0.1:8334:8334 \
            lnzap/btcd

2.  Verify that the container is running and btcd node is downloading the blockchain

        $ docker ps
        CONTAINER ID        IMAGE                         COMMAND             CREATED             STATUS              PORTS                                              NAMES
        d0e1076b2dca        lnzap/btcd:latest            "btcd_oneshot"       2 seconds ago       Up 1 seconds        127.0.0.1:8334->8334/tcp, 0.0.0.0:8333->8333/tcp   btcd-node

3.  You can then access the daemon's output thanks to the [docker logs command](https://docs.docker.com/reference/commandline/cli/#logs)

        docker logs -f btcd-node

4.  Install optional init scripts for upstart and systemd are in the `init` directory.

## Documentation

- Additional documentation in the [docs folder](docs).
