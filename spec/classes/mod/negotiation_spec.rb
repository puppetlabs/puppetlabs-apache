# frozen_string_literal: true

require 'spec_helper'

describe 'apache::mod::negotiation', type: :class do
  it_behaves_like 'a mod class, without including apache'
  describe 'OS independent tests' do
    include_examples 'Debian 11'

    context 'default params' do
      it { is_expected.to contain_class('apache') }

      it do
        expect(subject).to contain_file('negotiation.conf').with(ensure: 'file',
                                                                 content: 'LanguagePriority en ca cs da de el eo es et fr he hr it ja ko ltz nl nn no pl pt pt-BR ru sv zh-CN zh-TW
ForceLanguagePriority Prefer Fallback
')
      end
    end

    context 'with force_language_priority parameter' do
      let :params do
        { force_language_priority: 'Prefer' }
      end

      it do
        expect(subject).to contain_file('negotiation.conf').with(ensure: 'file',
                                                                 content: %r{^ForceLanguagePriority Prefer$})
      end
    end

    context 'with language_priority parameter' do
      let :params do
        { language_priority: ['en', 'es'] }
      end

      it do
        expect(subject).to contain_file('negotiation.conf').with(ensure: 'file',
                                                                 content: %r{^LanguagePriority en es$})
      end
    end
  end
end
