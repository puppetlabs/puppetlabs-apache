Facter.add(:apache_version) do
  confine kernel: ['FreeBSD', 'Linux']
  setcode do
    apache_version = nil

    if Facter::Util::Resolution.which('httpd')
      apache_version = Facter::Util::Resolution.exec('httpd -V 2>&1')
      Facter.debug "Matching httpd '#{apache_version}'"
    elsif Facter::Util::Resolution.which('apache2')
      apache_version = Facter::Util::Resolution.exec('apache2 -V 2>&1')
      Facter.debug "Matching apache2 '#{apache_version}'"
    elsif Facter::Util::Resolution.which('apachectl')
      apache_version = Facter::Util::Resolution.exec('apachectl -v 2>&1')
      Facter.debug "Matching apachectl '#{apache_version}'"
    elsif Facter::Util::Resolution.which('apache2ctl')
      apache_version = Facter::Util::Resolution.exec('apache2ctl -v 2>&1')
      Facter.debug "Matching apache2ctl '#{apache_version}'"
    end

    unless apache_version.nil?
      match = %r{^Server version: Apache\/(\d+.\d+(.\d+)?)}.match(apache_version)
      unless match.nil?
        match[1]
      end
    end
  end
end
