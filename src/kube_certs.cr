require "./data"

# Class for generating the Certs for setting up a simple kubernetes cluster
# The goal was to make the cert generation in Kubernetes the hard way
# much more simple.
class KubeCerts
  # Generate an OpenSSL config file for specifiying alternate DNS and IP
  # entries to associate with the certificate.
  def gen_config(dns : Array(String), ips : Array(String))
    return if dns.empty? && ips.empty?

    openssl_config = Data.openssl_template

    dns.each_with_index(offset: 1) do |dns, i|
      openssl_config += "DNS.#{i} = #{dns}\n"
    end
    ips.each_with_index(offset: 1) do |ip, i|
      openssl_config += "IP.#{i} = #{ip}\n"
    end

    openssl_config
  end

  def gen_commands(name, subject, config_file = nil, gen_ca = false)
    req_config = config_file ? " -config #{config_file}" : "" 
    req_config_2 = config_file ? " -extensions v3_req -extfile #{config_file}" : ""
    ca_args = gen_ca ? "-signkey ca.key" : "-CA ca.crt -CAkey ca.key"
    # Create private key for CA
    # Create CSR using the private key
    # Self sign the csr using its own private key
    <<-COMMANDS
      openssl genrsa -out #{name}.key 2048
      openssl req -new -key #{name}.key -subj "#{subject}" -out #{name}.csr#{req_config}
      openssl x509 -req -in #{name}.csr #{ca_args} -CAcreateserial -out #{name}.crt#{req_config_2} -days 1000
      COMMANDS
  end

  def gen(name, subject, ips, dns, config_file = nil, gen_ca = false, verbose = true, live = false)
    generated_config_file = gen_config(dns, ips)
    if generated_config_file
      puts "---#{name}.cnf---", generated_config_file if verbose
      config_file = "#{name}.cnf"

      File.write(config_file, generated_config_file) if live
    end

    str = gen_commands(name, subject, config_file: config_file, gen_ca: gen_ca)
    puts "---commands---", str if verbose
    str.lines.each { |line| `#{line}` } if live
  end
end