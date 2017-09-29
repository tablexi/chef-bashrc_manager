require_relative 'spec_helper'

EtcPwnam = Struct.new(:name, :gid)

describe 'test::bashrc_manager' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(step_into: ['bashrc_manager'])
  end

  let(:test1_content) do
    <<-TXT
# Managed by Chef.  Local changes will be overwritten.
test1
    TXT
  end

  before do
    pw_user = EtcPwnam.new
    pw_user.name = 'test_user'
    pw_user.gid = 'users'

    allow(Dir).to receive(:home).and_call_original
    allow(Etc).to receive(:getpwnam).and_call_original

    allow(Dir).to receive(:home).with('test_user').and_return('/home/test_user')
    allow(Etc).to receive(:getpwnam).with('test_user').and_return(pw_user)
  end

  context 'action create' do
    before do
      allow(File).to receive(:exist?).and_call_original
      allow(IO).to receive(:read).and_call_original
    end

    context 'init' do
      context 'default' do
        before do
          allow(File).to receive(:exist?).with('/home/test_user/.bashrc').and_return(true)
          allow(File).to receive(:exist?).with('/home/test_user/.bashrc.d/init').and_return(false)
          allow(IO).to receive(:read).with('/home/test_user/.bashrc').and_return('')
          chef_run.converge described_recipe
        end

        it 'to create .bashrc.d directory' do
          expect(chef_run).to create_directory('/home/test_user/.bashrc.d')
        end

        it 'to create .bashrc.d/init file' do
          expect(chef_run).to create_file('/home/test_user/.bashrc.d/init')
        end

        it 'to replace .bashrc with cookbook file' do
          expect(chef_run).to create_cookbook_file('/home/test_user/.bashrc')
        end
      end

      context 'to touch' do
        before do
          chef_run.converge described_recipe
        end

        it '.bashrc.d/init file' do
          expect(chef_run).to touch_file('/home/test_user/.bashrc.d/init')
        end
      end
    end

    context 'test1' do
      before do
        chef_run.converge described_recipe
      end

      it 'create .bashrc.d/test1 file' do
        expect(chef_run).to create_file('/home/test_user/.bashrc.d/test1')
      end

      it 'append chef warning to .bashrc.d/test1 file' do
        expect(chef_run).to render_file('/home/test_user/.bashrc.d/test1')
          .with_content(test1_content)
      end

      it 'not log warning' do
        expect(chef_run).not_to write_log('bashrc_manager_test1')
      end
    end

    context 'log' do
      before do
        allow(File).to receive(:exist?).with('/home/test_user/.bashrc').and_return(true)
        allow(File).to receive(:exist?).with('/home/test_user/.bashrc.d/init').and_return(true)
        allow(IO).to receive(:read).with('/home/test_user/.bashrc').and_return('')
        allow(IO).to receive(:read)
          .with('/home/test_user/.bashrc.d/init')
          .and_return(test1_content)
        chef_run.converge described_recipe
      end

      it 'warning' do
        expect(chef_run).to write_log('bashrc_manager_test1').with(level: :warn)
      end
    end
  end

  context 'action remove' do
    before do
      chef_run.converge described_recipe
    end

    it 'delete .bashrc.d/test2 file' do
      expect(chef_run).to delete_file('/home/test_user/.bashrc.d/test2')
    end
  end

  context 'matcher' do
    before do
      chef_run.converge described_recipe
    end

    it 'add_bashrc' do
      expect(chef_run).to add_bashrc_manager('test1')
    end

    it 'remove_bashrc' do
      expect(chef_run).to remove_bashrc_manager('test2')
    end
  end
end
