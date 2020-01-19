require "admiral"
require "./kube_certs"
require "./data"

class Main < Admiral::Command
  define_help

  define_argument name,
    description: "The name of the certificate pair to generate",
    required: true

  define_argument subject,
    description: "The subject string to set for the certificate. e.g. \"/CN=admin/O=system:masters\"",
    required: true

  define_flag config_file : String,
    description: "A config file to pass when generating the cert",
    default: nil,
    long: "config",
    short: "c"

  define_flag verbose : Bool,
    description: "Output the actual openssl commands that are to be run",
    default: false,
    short: "v"

  define_flag dry_run : Bool,
    description: "Don't actually generate certificates (also turns on verbose mode)",
    default: false,
    short: "v"

  define_flag dns : Array(String),
    description: "Alternative domain that is valid for this certificate (you can specify this command multiple times)",
    default:  [] of String

  define_flag ip : Array(String),
    description: "Alternative IP that is valid for this certificate (you can specify this command multiple times)",
    default: [] of String

  def run
    check_openssl unless flags.dry_run

    # If dry-run is set then we automatically turn on verbose mode as this is the main
    # reason to run in dry-run mode. Some may wish to use this as a saftey switch but
    # they can just not call the command so I'll only cater to the common use case.
    verbose = flags.dry_run || flags.verbose

    kc = KubeCerts.new
    kc.gen(
      arguments.name,
      arguments.subject,
      config_file: flags.config_file,
      dns: flags.dns,
      ips: flags.ip,
      gen_ca: (arguments.name == "ca"),
      verbose: verbose,
      live: !flags.dry_run
    )
  end

  def help
    description = "Generate simple certs simply\n"
    long_description = Data.help_text

    puts [
      help_usage,
      description,
      help_arguments,
      help_flags,
      help_sub_commands,
      long_description,
    ].reject(&.strip.empty?).join("\n")
  end

  def check_openssl
    `which openssl`

    abort("You must have `openssl` installed and available on your PATH in order to use this tool") unless $?.success?
  end
end

Main.run

# Hack to prevent a segfault for static linking
{% if flag?(:static) %}
  require "llvm/lib_llvm"
  require "llvm/enums"
{% end %}