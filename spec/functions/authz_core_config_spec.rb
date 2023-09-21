# frozen_string_literal: true

require 'spec_helper'

describe 'apache::authz_core_config' do
  let(:input1) do
    {
      'Require' => [
        'user foo',
        'user bar',
      ]
    }
  end

  let(:input2) do
    {
      'require_all' => {
        'require_any' => {
          'require' => ['user superadmin'],
          'require_all' => {
            'require' => ['group admins', 'ldap-group "cn=Administrators,o=Airius"']
          }
        },
        'require_none' => {
          'require' => ['group temps', 'ldap-group "cn=Temporary Employees,o=Airius"']
        }
      }
    }
  end
  let(:output2) do
    [
      '  <RequireAll>',
      '    <RequireAny>',
      '      Require user superadmin',
      '      <RequireAll>',
      '        Require group admins',
      '        Require ldap-group "cn=Administrators,o=Airius"',
      '      </RequireAll>',
      '    </RequireAny>',
      '    <RequireNone>',
      '      Require group temps',
      '      Require ldap-group "cn=Temporary Employees,o=Airius"',
      '    </RequireNone>',
      '  </RequireAll>',
    ]
  end

  it { is_expected.to run.with_params(nil).and_raise_error(StandardError) }
  it { is_expected.to run.with_params([]).and_raise_error(StandardError) }
  it { is_expected.to run.with_params({}).and_return([]) }
  it { is_expected.to run.with_params(input1).and_return(['  Require user foo', '  Require user bar']) }
  it { is_expected.to run.with_params(input2).and_return(output2) }
end
