# gencert

Generate simple certs simply

## Install via download (currently Linux only)

1. [Download gencert](https://github.com/gerrywastaken/gencert/releases/latest)
2. chmod +x gencert
3. ./gencert --help

## Run via Docker

1. Create a Bash alias `alias gencert="docker run -v $PWD/kubecerts:/app gerrywastaken/gencert"`
2. `gencert ca /CN=KUBERNETES-CA`
3. `gencert admin /CN=admin/O=system:masters`

## Run via Crystal

1. Install Crystal https://crystal-lang.org/install/
2. Download this code
3. Build `shards build gencert`
4. Run `bin/gencert --help`

## Usage

Kubernetes the... ummmm hard way cert generation:

```shell
# This script expects a ca.crt and ca.key to exist in the current directory.
# If you do not have one you can just generate it:

gencert ca /CN=KUBERNETES-CA

gencert admin /CN=admin/O=system:masters
gencert kube-controller-manager /CN=system:kube-controller-manager
gencert kube-proxy /CN=system:kube-proxy
gencert kube-scheduler /CN=system:kube-scheduler
gencert service-account /CN=service-accounts

# Pass alternate ips or domains to associate with the certificate

gencert kube-apiserver /CN=kube-apiserver \
  --dns kubernetes \
  --dns kubernetes.default \
  --dns kubernetes.default.svc \
  --dns kubernetes.default.svc.cluster.local \
  --ip 10.96.0.1 \
  --ip 192.168.5.11 \
  --ip 192.168.5.12 \
  --ip 192.168.5.30 \
  --ip 127.0.0.1

# Or you can just pass an openssl config file

gencert etcd-server /CN=etcd-server -c ../openssl-etcd.cnf
gencert worker-1 /CN=system:node:worker-1/O=system:nodes -c ../openssl-worker-1.cnf
```

## Development

1. Install Crystal: https://crystal-lang.org/install/
2. Download this code and navigate to the directory
3. Make your change
4. Compile: `shards build --debug gencert`
5. Test: `bin/gencert --help`

## Contributing

1. Fork it (<https://github.com/gerrywastaken/gencert/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Gerry](https://github.com/gerrywastaken) - creator and maintainer
