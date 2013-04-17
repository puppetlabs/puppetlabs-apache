# determine the version of apache installed
#
# borrowed from here https://gist.github.com/mrpatrick/1819239#file_httpd.rb

osfamily = Facter.value('osfamily')
if osfamily == 'Debian'
apache_version=`/usr/sbin/apache2 -v | sed 's/[://]/ /g' |awk '/version/ {print $4}'`
else
apache_version=`/usr/sbin/httpd -v | sed 's/[://]/ /g' |awk '/version/ {print $4}'`
end
Facter.add("apache_version") do
  setcode do
    if apache_version
      apache_version
    else
      "0"
    end
  end
end
