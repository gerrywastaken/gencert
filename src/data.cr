class Data
  def self.help_text
    <<-DOC
      Examples
      --------

      Generate a CA certificate key pair. The name "ca" is treated
      specially to denote that you want to create a Certificate Authorithy (CA):

        gencert ca /CN=KUBERNETES-CA

      Generate a normal certificate (this expects a CA to already exist in the current directory):

        gencert kube-scheduler /CN=system:kube-scheduler

      Generate a normal certificate but with alternate ips or domains to associate with the certificate:

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

      If you really wish you can pass an open ssl config file instead of directly specifying alternative IPs/domains:

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