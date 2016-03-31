Facter.add(:apache_version) do
  setcode do
    if Facter::Util::Resolution.which('apachectl')
      apache_version = Facter::Util::Resolution.exec('apachectl -v 2>&1')
      %r{^Server version: Apache\/([\w\.]+) \(([\w ]*)\)}.match(apache_version)[1]
    end
  end
end
