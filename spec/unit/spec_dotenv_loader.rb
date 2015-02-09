require 'spec_helper'
require 'dotenv_loader'

module RaspberryPiControlPanel
  describe DotenvLoader do
    env_file = '.env.test'

    subject { DotenvLoader.new(env_file) }

    context "missing #{env_file} file" do
      it 'results in runtime error' do
        expect { subject }.to raise_error(RuntimeError, DotenvLoader.dot_env_file_not_found_message(env_file))
      end
    end
  end
end
