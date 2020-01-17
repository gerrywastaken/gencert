class Data
  def self.help_text
    <<-DOC
      # Kubernetes the ummmm... hard way cert generation:

      # This script expects a ca.crt and ca.key to exist in the current directory.
      # If you don't have one you can just generate it:

      gencert ca /CN=KUBERNETES-CA
      
      gencert admin /CN=admin/O=system:masters
      gencert kube-controller-manager /CN=system:kube-controller-manager
      gencert kube-proxy /CN=system:kube-proxy
      gencert kube-scheduler /CN=system:kube-scheduler
      gencert service-account /CN=service-accounts
      
      # Pass alternate ips or domains to associate with the certificate

      gencert kube-apiserver /CN=kube-apiserver \\
        --dns kubernetes \\
        --dns kubernetes.default \\
        --dns kubernetes.default.svc \\
        --dns kubernetes.default.svc.cluster.local \\
        --ip 10.96.0.1 \\
        --ip 192.168.5.11 \\
        --ip 192.168.5.12 \\
        --ip 192.168.5.30 \\
        --ip 127.0.0.1

      # Or you can just pass an openssl config file

      gencert etcd-server /CN=etcd-server -c ../openssl-etcd.cnf
      gencert worker-1 /CN=system:node:worker-1/O=system:nodes -c ../openssl-worker-1.cnf
      DOC
  end

  def self.openssl_template
    <<-TEMPLATE
      [req]
      req_extensions = v3_req
      distinguished_name = req_distinguished_name
      [req_distinguished_name]
      [ v3_req ]
      basicConstraints = CA:FALSE
      keyUsage = nonRepudiation, digitalSignature, keyEncipherment
      subjectAltName = @alt_names
      [alt_names]

      TEMPLATE
  end
end