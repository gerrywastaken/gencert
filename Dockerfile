FROM alpine:latest as builder
RUN apk add -u crystal shards libc-dev
WORKDIR /src
COPY shard.lock shard.yml ./
COPY src/ src/
RUN shards install
RUN ls -laht
RUN crystal build --release --static src/main.cr -o /src/gencert

FROM alpine:latest
RUN apk add -u openssl
WORKDIR /app
COPY --from=builder /src/gencert /bin/gencert
CMD [ "--help" ]
ENTRYPOINT [ "gencert" ]
