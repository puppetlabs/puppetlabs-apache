# frozen_string_literal: true

# @summary
#   Function to generate the authz_core configuration directives.
#
Puppet::Functions.create_function(:'apache::authz_core_config') do
  # @param config
  #   The input as JSON format.
  #
  # @return
  #   Returns the authz_core config directives in array.
  #
  # @example
  #
  #    arg = {
  #      require_all => {
  #       'require_any' => {
  #         'require' => ['user superadmin'],
  #         'require_all' => {
  #           'require' => ['group admins'],
  #         },
  #        },
  #       'require_none' => {
  #         'require' => ['group temps']
  #       }
  #      }
  #    }
  #
  #    apache::bool2httpd(arg)
  #    returns :
  #    [
  #      "  <RequireAll>",
  #      "    <RequireAny>",
  #      "      Require user superadmin",
  #      "      <RequireAll>",
  #      "        Require group admins",
  #      "        Require ldap-group \"cn=Administrators,o=Airius\"",
  #      "      </RequireAll>",
  #      "    </RequireAny>",
  #      "    <RequireNone>",
  #      "      Require group temps",
  #      "      Require ldap-group \"cn=Temporary Employees,o=Airius\"",
  #      "    </RequireNone>",
  #      "  </RequireAll>"
  #    ]
  #
  dispatch :authz_core_config do
    param 'Hash', :config
    return_type 'Array'
  end

  private

  def build_directive(value)
    value.split('_').map(&:capitalize).join
  end

  def authz_core_config(config, count = 1)
    result_string = []
    config.map do |key, value|
      directive = build_directive(key)
      if value.is_a?(Hash)
        result_string << spacing("<#{directive}>", count)
        result_string << authz_core_config(value, count + 1)
        result_string << spacing("</#{directive}>", count)
      else
        value.map do |v|
          result_string << spacing("#{directive} #{v}", count)
        end
      end
    end
    result_string.flatten
  end

  def spacing(string, count)
    ('  ' * count) + string
  end
end
