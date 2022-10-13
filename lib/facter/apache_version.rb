# frozen_string_literal: true

Facter.add(:apache_version) do
  confine kernel: ['FreeBSD', 'Linux']
  setcode do
    apache_version = nil

    if Facter::Core::Execution.which('httpd')
      apache_version = Facter::Core::Execution.execute('httpd -V 2>&1')
      Facter.debug "Matching httpd '#{apache_version}'"
    elsif Facter::Core::Execution.which('apache2')
      apache_version = Facter::Core::Execution.execute('apache2 -V 2>&1')
      Facter.debug "Matching apache2 '#{apache_version}'"
    elsif Facter::Core::Execution.which('apachectl')
      apache_version = Facter::Core::Execution.execute('apachectl -v 2>&1')
      Facter.debug "Matching apachectl '#{apache_version}'"
    elsif Facter::Core::Execution.which('apache2ctl')
      apache_version = Facter::Core::Execution.execute('apache2ctl -v 2>&1')
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
