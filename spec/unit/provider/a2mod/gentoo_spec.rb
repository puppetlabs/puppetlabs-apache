#!/usr/bin/env rspec

require 'spec_helper'

provider_class = Puppet::Type.type(:a2mod).provider(:gentoo)

describe provider_class do
  before :each do
    provider_class.clear
  end

  [:conf_file, :instances, :modules, :initvars, :conf_file, :clear].each do |method|
    it "should respond to the class method #{method}" do
      provider_class.should respond_to(method)
    end
  end

  describe "when fetching modules" do
    before do
      @filetype = mock()
    end

    it "should return a sorted array of the defined parameters" do
      @filetype.should_receive(:read) { %Q{APACHE2_OPTS="-D FOO -D BAR -D BAZ"\n} }
      provider_class.should_receive(:filetype) { @filetype }

      provider_class.modules.should == %w{bar baz foo}
    end

    it "should cache the module list" do
      @filetype.should_receive(:read).once { %Q{APACHE2_OPTS="-D FOO -D BAR -D BAZ"\n} }
      provider_class.should_receive(:filetype).once { @filetype }

      2.times { provider_class.modules.should == %w{bar baz foo} }
    end

    it "should normalize parameters" do
      @filetype.should_receive(:read) { %Q{APACHE2_OPTS="-D FOO -D BAR -D BAR"\n} }
      provider_class.should_receive(:filetype) { @filetype }

      provider_class.modules.should == %w{bar foo}
    end
  end

  describe "when prefetching" do
    it "should match providers to resources" do
      provider = mock("ssl_provider", :name => "ssl")
      resource = mock("ssl_resource")
      resource.should_receive(:provider=).with(provider)

      provider_class.should_receive(:instances) { [provider] }
      provider_class.prefetch("ssl" => resource)
    end
  end

  describe "when flushing" do
    before :each do
      @filetype = mock()
      @filetype.stub(:backup)
      provider_class.should_receive(:filetype).at_least(:once) { @filetype }

      @info = stub()
      @info.stub(:[]).with(:name) { "info" }
      @info.stub(:provider=)

      @mpm = stub()
      @mpm.stub(:[]).with(:name) { "mpm" }
      @mpm.stub(:provider=)

      @ssl = stub()
      @ssl.stub(:[]).with(:name) { "ssl" }
      @ssl.stub(:provider=)
    end

    it "should add modules whose ensure is present" do
      @filetype.should_receive(:read).at_least(:once) { %Q{APACHE2_OPTS=""} }
      @filetype.should_receive(:write).with(%Q{APACHE2_OPTS="-D INFO"})

      @info.stub(:should).with(:ensure) { :present }
      provider_class.prefetch("info" => @info)

      provider_class.flush
    end

    it "should remove modules whose ensure is present" do
      @filetype.should_receive(:read).at_least(:once) { %Q{APACHE2_OPTS="-D INFO"} }
      @filetype.should_receive(:write).with(%Q{APACHE2_OPTS=""})

      @info.stub(:should).with(:ensure) { :absent }
      @info.stub(:provider=)
      provider_class.prefetch("info" => @info)

      provider_class.flush
    end

    it "should not modify providers without resources" do
      @filetype.should_receive(:read).at_least(:once) { %Q{APACHE2_OPTS="-D INFO -D MPM"} }
      @filetype.should_receive(:write).with(%Q{APACHE2_OPTS="-D MPM -D SSL"})

      @info.stub(:should).with(:ensure) { :absent }
      provider_class.prefetch("info" => @info)

      @ssl.stub(:should).with(:ensure) { :present }
      provider_class.prefetch("ssl" => @ssl)

      provider_class.flush
    end

    it "should write the modules in sorted order" do
      @filetype.should_receive(:read).at_least(:once) { %Q{APACHE2_OPTS=""} }
      @filetype.should_receive(:write).with(%Q{APACHE2_OPTS="-D INFO -D MPM -D SSL"})

      @mpm.stub(:should).with(:ensure) { :present }
      provider_class.prefetch("mpm" => @mpm)
      @info.stub(:should).with(:ensure) { :present }
      provider_class.prefetch("info" => @info)
      @ssl.stub(:should).with(:ensure) { :present }
      provider_class.prefetch("ssl" => @ssl)

      provider_class.flush
    end

    it "should write the records back once" do
      @filetype.should_receive(:read).at_least(:once) { %Q{APACHE2_OPTS=""} }
      @filetype.should_receive(:write).once.with(%Q{APACHE2_OPTS="-D INFO -D SSL"})

      @info.stub(:should).with(:ensure) { :present }
      provider_class.prefetch("info" => @info)

      @ssl.stub(:should).with(:ensure) { :present }
      provider_class.prefetch("ssl" => @ssl)

      provider_class.flush
    end

    it "should only modify the line containing APACHE2_OPTS" do
      @filetype.should_receive(:read).at_least(:once) { %Q{# Comment\nAPACHE2_OPTS=""\n# Another comment} }
      @filetype.should_receive(:write).once.with(%Q{# Comment\nAPACHE2_OPTS="-D INFO"\n# Another comment})

      @info.stub(:should).with(:ensure) { :present }
      provider_class.prefetch("info" => @info)
      provider_class.flush
    end

    it "should restore any arbitrary arguments" do
      @filetype.should_receive(:read).at_least(:once) { %Q{APACHE2_OPTS="-Y -D MPM -X"} }
      @filetype.should_receive(:write).once.with(%Q{APACHE2_OPTS="-Y -X -D INFO -D MPM"})

      @info.stub(:should).with(:ensure) { :present }
      provider_class.prefetch("info" => @info)
      provider_class.flush
    end

    it "should backup the file once if changes were made" do
      @filetype.should_receive(:read).at_least(:once) { %Q{APACHE2_OPTS=""} }
      @filetype.should_receive(:write).once.with(%Q{APACHE2_OPTS="-D INFO -D SSL"})

      @info.stub(:should).with(:ensure) { :present }
      provider_class.prefetch("info" => @info)

      @ssl.stub(:should).with(:ensure) { :present }
      provider_class.prefetch("ssl" => @ssl)

      @filetype.unstub(:backup)
      @filetype.should_receive(:backup)
      provider_class.flush
    end

    it "should not write the file or run backups if no changes were made" do
      @filetype.should_receive(:read).at_least(:once) { %Q{APACHE2_OPTS="-X -D INFO -D SSL -Y"} }
      @filetype.should_receive(:write).never

      @info.stub(:should).with(:ensure) { :present }
      provider_class.prefetch("info" => @info)

      @ssl.stub(:should).with(:ensure) { :present }
      provider_class.prefetch("ssl" => @ssl)

      @filetype.unstub(:backup)
      @filetype.should_receive(:backup).never
      provider_class.flush
    end
  end
end
