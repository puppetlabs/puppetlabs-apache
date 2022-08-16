# frozen_string_literal: true

require 'spec_helper'

describe 'Apache::Vhost::Priority' do
  # Pattern
  it { is_expected.to allow_value('10') }
  it { is_expected.to allow_value('010') }
  it { is_expected.not_to allow_value('') }
  it { is_expected.not_to allow_value('a') }
  it { is_expected.not_to allow_value('a1') }
  it { is_expected.not_to allow_value('1a') }

  # Integer
  it { is_expected.to allow_value(0) }
  it { is_expected.to allow_value(1) }

  # Boolean
  it { is_expected.to allow_value(true) } # Technically an illegal value
  it { is_expected.to allow_value(false) }

  it { is_expected.not_to allow_value(nil) }
end
