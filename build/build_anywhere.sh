#!/bin/bash
docker run --rm -it -v $PWD:/app -w /app durosoft/crystal-alpine:latest crystal build src/main.cr -o build/gencert --release --static --no-debug