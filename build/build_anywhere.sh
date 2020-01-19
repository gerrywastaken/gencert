#!/bin/bash
GID=$(id -g $USER)
docker build . --target builder -t compile_gencert && \
mkdir -p $PWD/builds && \
docker run --user $UID:$GID --rm -v $PWD/builds:/app compile_gencert cp /bin/gencert /app && \
sudo chown $USER:$GID $PWD/builds/gencert
