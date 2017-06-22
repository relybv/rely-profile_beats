require 'spec_helper'

describe 'profile_beats' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge({
            :concat_basedir => "/foo"
          })
        end

        context "profile_beats class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('profile_beats') }
          it { is_expected.to contain_class('profile_beats::install') }
          it { is_expected.to contain_class('profile_beats::config') }
          it { is_expected.to contain_class('profile_beats::service') }
          it { is_expected.to contain_class('profile_beats::params') }
          it { is_expected.to contain_class('filebeat') }

          it { is_expected.to contain_filebeat__prospector('syslogs') }

          case facts[:osfamily]
          when 'Debian'
            it { is_expected.to contain_apt__source('elasticrepo') }
          else
            it { is_expected.not_to contain_apt__source('elasticrepo') }
          end
        end
      end
    end
  end
end
