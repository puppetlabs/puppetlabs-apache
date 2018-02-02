require 'spec_helper'

provider_class = Puppet::Type.type(:a2mod).provider(:gentoo)

describe provider_class do
  before :each do
    provider_class.clear
  end

  [:conf_file, :instances, :modules, :initvars, :conf_file, :clear].each do |method|
    it "should respond to the class method #{method}" do
      expect(provider_class).to respond_to(method)
    end
  end

  # rubocop:disable RSpec/MessageSpies
  describe 'when fetching modules' do
    let(:filetype) do
      double
    end

    it 'returns a sorted array of the defined parameters' do # rubocop:disable RSpec/MultipleExpectations
      expect(filetype).to receive(:read).and_return(%(APACHE2_OPTS="-D FOO -D BAR -D BAZ"\n))
      expect(provider_class).to receive(:filetype) { filetype }

      expect(provider_class.modules).to eq(%w[bar baz foo])
    end

    it 'caches the module list' do # rubocop:disable RSpec/MultipleExpectations
      expect(filetype).to receive(:read).once { %(APACHE2_OPTS="-D FOO -D BAR -D BAZ"\n) } # rubocop:disable Lint/AmbiguousBlockAssociation
      expect(provider_class).to receive(:filetype).once { filetype } # rubocop:disable Lint/AmbiguousBlockAssociation

      2.times { expect(provider_class.modules).to eq(%w[bar baz foo]) }
    end

    it 'normalizes parameters' do
      filetype.expects(:read).returns(%(APACHE2_OPTS="-D FOO -D BAR -D BAR"\n))
      provider_class.expects(:filetype).returns(filetype)

      expect(provider_class.modules).to eq(%w[bar foo])
    end
  end

  describe 'when prefetching' do
    it 'matches providers to resources' do
      provider = instance_double('ssl_provider', name: 'ssl')
      resource = instance_double('ssl_resource')
      resource.expects(:provider=).with(provider)

      expect(provider_class).to receive(:instances) { [provider] }
      provider_class.prefetch('ssl' => resource)
    end
  end

  # rubocop:disable RSpec/InstanceVariable
  describe 'when flushing' do
    before :each do
      @filetype = double
      allow(@filetype).to receive(:backup)
      allow(provider_class).to receive(:filetype).at_least(:once) { @filetype }

      @info = double
      allow(@info).to receive(:[]).with(:name) { 'info' }
      allow(@info).to receive(:provider=)

      @mpm = double
      allow(@mpm).to receive(:[]).with(:name) { 'mpm' }
      allow(@mpm).to receive(:provider=)

      @ssl = double
      allow(@ssl).to receive(:[]).with(:name) { 'ssl' }
      allow(@ssl).to receive(:provider=)
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'adds modules whose ensure is present' do
      expect(@filetype).to receive(:read).at_least(:once) { %(APACHE2_OPTS="") }
      expect(@filetype).to receive(:write).with(%(APACHE2_OPTS="-D INFO"))

      allow(@info).to receive(:should).with(:ensure) { :present }
      provider_class.prefetch('info' => @info)

      provider_class.flush
    end

    # rubocop:disable RSpec/ExampleLength
    it 'removes modules whose ensure is present' do
      expect(@filetype).to receive(:read).at_least(:once) { %(APACHE2_OPTS="-D INFO") }
      expect(@filetype).to receive(:write).with(%(APACHE2_OPTS=""))

      allow(@info).to receive(:should).with(:ensure) { :absent }
      allow(@info).to receive(:provider=)
      provider_class.prefetch('info' => @info)

      provider_class.flush
    end

    it 'does not modify providers without resources' do
      expect(@filetype).to receive(:read).at_least(:once) { %(APACHE2_OPTS="-D INFO -D MPM") }
      expect(@filetype).to receive(:write).with(%(APACHE2_OPTS="-D MPM -D SSL"))

      allow(@info).to receive(:should).with(:ensure) { :absent }
      provider_class.prefetch('info' => @info)

      allow(@ssl).to receive(:should).with(:ensure) { :present }
      provider_class.prefetch('ssl' => @ssl)

      provider_class.flush
    end

    it 'writes the modules in sorted order' do
      expect(@filetype).to receive(:read).at_least(:once) { %(APACHE2_OPTS="") }
      expect(@filetype).to receive(:write).with(%(APACHE2_OPTS="-D INFO -D MPM -D SSL"))

      allow(@mpm).to receive(:should).with(:ensure) { :present }
      provider_class.prefetch('mpm' => @mpm)
      allow(@info).to receive(:should).with(:ensure) { :present }
      provider_class.prefetch('info' => @info)
      allow(@ssl).to receive(:should).with(:ensure) { :present }
      provider_class.prefetch('ssl' => @ssl)

      provider_class.flush
    end

    it 'writes the records back once' do
      expect(@filetype).to receive(:read).at_least(:once) { %(APACHE2_OPTS="") }
      expect(@filetype).to receive(:write).once.with(%(APACHE2_OPTS="-D INFO -D SSL"))

      allow(@info).to receive(:should).with(:ensure) { :present }
      provider_class.prefetch('info' => @info)

      allow(@ssl).to receive(:should).with(:ensure) { :present }
      provider_class.prefetch('ssl' => @ssl)

      provider_class.flush
    end

    it 'onlies modify the line containing APACHE2_OPTS' do
      expect(@filetype).to receive(:read).at_least(:once) { %(# Comment\nAPACHE2_OPTS=""\n# Another comment) }
      expect(@filetype).to receive(:write).once.with(%(# Comment\nAPACHE2_OPTS="-D INFO"\n# Another comment))

      allow(@info).to receive(:should).with(:ensure) { :present }
      provider_class.prefetch('info' => @info)
      provider_class.flush
    end

    it 'restores any arbitrary arguments' do
      expect(@filetype).to receive(:read).at_least(:once) { %(APACHE2_OPTS="-Y -D MPM -X") }
      expect(@filetype).to receive(:write).once.with(%(APACHE2_OPTS="-Y -X -D INFO -D MPM"))

      allow(@info).to receive(:should).with(:ensure) { :present }
      provider_class.prefetch('info' => @info)
      provider_class.flush
    end

    it 'backups the file once if changes were made' do
      expect(@filetype).to receive(:read).at_least(:once) { %(APACHE2_OPTS="") }
      expect(@filetype).to receive(:write).once.with(%(APACHE2_OPTS="-D INFO -D SSL"))

      allow(@info).to receive(:should).with(:ensure) { :present }
      provider_class.prefetch('info' => @info)

      allow(@ssl).to receive(:should).with(:ensure) { :present }
      provider_class.prefetch('ssl' => @ssl)

      @filetype.unstub(:backup)
      @filetype.expects(:backup)
      provider_class.flush
    end

    it 'does not write the file or run backups if no changes were made' do
      expect(@filetype).to receive(:read).at_least(:once) { %(APACHE2_OPTS="-X -D INFO -D SSL -Y") }
      expect(@filetype).to receive(:write).never

      allow(@info).to receive(:should).with(:ensure) { :present }
      provider_class.prefetch('info' => @info)

      allow(@ssl).to receive(:should).with(:ensure) { :present }
      provider_class.prefetch('ssl' => @ssl)

      @filetype.unstub(:backup)
      @filetype.expects(:backup).never
      provider_class.flush
    end
    # rubocop:enable RSpec/ExampleLength
    # rubocop:enable RSpec/MultipleExpectations
  end
  # rubocop:enable RSpec/InstanceVariable
  # rubocop:enable RSpec/MessageSpies
end
