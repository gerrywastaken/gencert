FROM alpine:latest as builder
RUN apk add -u crystal shards libc-dev
WORKDIR /src
COPY src shard.lock shard.yml lib ./
COPY . .
RUN crystal build --release --static src/main.cr -o /src/gencert

FROM alpine:latest
RUN apk add -u openssl
WORKDIR /app
COPY --from=builder /src/gencert /bin/gencert
CMD [ "--help" ]
ENTRYPOINT [ "gencert" ]
