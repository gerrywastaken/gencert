#!/bin/bash
GID=$(id -g $USER)
docker build . --target builder -t compile_gencert && \
mkdir -p $PWD/gencert-linux && \
docker run --user $UID:$GID --rm -v $PWD/gencert-linux:/app compile_gencert cp /bin/gencert /app && \
sudo chown $USER:$GID $PWD/gencert-linux/gencert
cp -r examples LICENSE README.md gencert-linux
mkdir -p releases
tar -czvf releases/gencert-linux.tar.gz gencert-linux
