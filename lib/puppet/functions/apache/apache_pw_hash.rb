# Hashes a password in a format suitable for htpasswd files read by apache.
#
# Currently uses SHA-hashes, because although this format is considered insecure, its the
# most secure format supported by the most platforms.
Puppet::Functions.create_function(:'apache::apache_pw_hash') do
  dispatch :apache_pw_hash do
    required_param 'String[1]', :password
    return_type 'String'
  end

  def apache_pw_hash(password)
    require 'base64'
    '{SHA}' + Base64.strict_encode64(Digest::SHA1.digest(password))
  end
end
