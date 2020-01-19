# Needed because otherwise we end up with segfaults when doing static compliation
FROM jrei/crystal-alpine@sha256:192ff0c32ab9bc995989440d96333cd4a454cc688459709af193747e2f2f4e6b as builder
WORKDIR /src
COPY shard.lock shard.yml ./
COPY src/ src/
RUN shards install
RUN crystal build --release --static src/main.cr -o /bin/gencert

# We could use `scratch` instead if we didn't need `openssl`
FROM alpine:latest
RUN apk add -u openssl
WORKDIR /app
COPY --from=builder /bin/gencert /bin/gencert
CMD [ "--help" ]
ENTRYPOINT [ "gencert" ]
