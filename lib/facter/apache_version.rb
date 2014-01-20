commands = ["/usr/sbin/httpd", "/usr/sbin/apachectl", "/usr/sbin/apache2", "/usr/local/sbin/apachectl"]

commands.each do |cmd|
  if File.exists?(cmd)
    output = Facter::Util::Resolution.exec(cmd + " -v").to_s
    matches = /Apache\/([0-9]).([0-9]).([0-9]+)/.match(output)
    version = matches.nil? ? nil : matches.captures
    unless version.nil?
      Facter.add("apache_version") do
        setcode do
          version.join(".")
        end
      end
      Facter.add("apache_major") do
        setcode do
          version[0]
        end
      end
      Facter.add("apache_minor") do
        setcode do
          version[1]
        end
      end
      Facter.add("apache_revision") do
        setcode do
          version[2]
        end
      end
      break
    end
  end
end
