RSpec.configure do |c|
  c.before :each do
    # Ensure that we don't accidentally cache facts and environment
    # between test cases.
    Facter::Util::Loader.any_instance.stubs(:load_all)
    Facter.clear
    Facter.clear_messages
  end
end

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  # as soon as psh is updated, the following line can be removed
  config.mock_with :rspec
end

shared_examples :compile, compile: true do
  it { is_expected.to compile.with_all_deps }
end

shared_context 'a mod class, without including apache' do
  let(:facts) { on_supported_os['debian-8-x86_64'] }
end
