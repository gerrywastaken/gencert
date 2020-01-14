# gencert

Generate simple certs simply

## Installation

1. [Download gencert](https://github.com/gerrywastaken/gencert/releases/tag/v0.1.0) (currently only Linux) and run it.
2. There is no step 2

## Usage

Kubernetes the ummmm... hard way cert generation:

```
gencert ca /CN=KUBERNETES-CA
gencert admin /CN=admin/O=system:masters
gencert kube-controller-manager /CN=system:kube-controller-manager
gencert kube-proxy /CN=system:kube-proxy
gencert kube-scheduler /CN=system:kube-scheduler
gencert service-account /CN=service-accounts

gencert kube-apiserver /CN=kube-apiserver -c ../openssl.cnf
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

1. Fork it (<https://github.com/your-github-user/boo/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Gerry](https://github.com/gerrywastaken) - creator and maintainer
