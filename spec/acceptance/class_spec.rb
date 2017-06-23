if ENV['BEAKER'] == 'true'
  # running in BEAKER test environment
  require 'spec_helper_acceptance'
else
  # running in non BEAKER environment
  require 'serverspec'
  set :backend, :exec
end

describe 'profile_beats class' do

  context 'default parameters' do
    if ENV['BEAKER'] == 'true'
      # Using puppet_apply as a helper
      it 'should work idempotently with no errors' do
        pp = <<-EOS
        class { 'profile_beats': }
        EOS

        # Run it and test for errors
        apply_manifest(pp, :catch_failures => true)
      end
    end

    describe package('filebeat') do
      it { is_expected.to be_installed }
    end

    describe service('filebeat') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

  end
end
