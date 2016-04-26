require "spec_helper"
require "bundler-gtags/cli/gtags"

describe Bundler::Gtags::CLI::Gtags do
  use_app 'rake_app'

  let(:gem_dirs) {
    Dir['vendor/bundle/ruby/2.2.0/gems/*'].map { |dir| File.expand_path dir }
  }

  let(:options) { {} }

  let(:args) { [] }

  subject { described_class.new options, args }

  before do
    allow(subject).to receive(:`).with(/gtags/) { FileUtils.touch 'GTAGS' }
    allow(subject).to receive(:`).with(/direnv/) { FileUtils.touch '.envrc' }
    allow(subject).to receive(:gem_dirs) { gem_dirs }
  end

  it "creates GTAGS file" do
    subject.run
    gems_dir = 
    expect(File.exist? 'vendor/bundle/ruby/2.2.0/gems/colored-1.2/GTAGS').to eq true
    expect(File.exist? 'vendor/bundle/ruby/2.2.0/gems/rake-11.1.2/GTAGS').to eq true
  end

  describe '.envrc' do
    let(:dirs) {
      [
        Dir.pwd,
        File.expand_path('vendor/bundle/ruby/2.2.0/gems/colored-1.2'),
        File.expand_path('vendor/bundle/ruby/2.2.0/gems/rake-11.1.2')
      ]
    }

    it "creates .envrc file" do
      subject.run
      expect(File.exist? '.envrc').to eq true
      expect(open('.envrc', &:read))
      .to eq "export GTAGSLIBPATH=#{dirs.join(':')}\n"
    end

    it "updates .envrc file if modfied" do
      open('.envrc', 'w') { |f| f << "# first line\n" }
      subject.run

      lines = [
        "# first line\n",
        "export GTAGSLIBPATH=#{dirs.join(':')}\n"
      ]
      expect(open('.envrc', &:read)).to eq lines.join
    end

    it "untouches .envrc file if identical" do
      lines = [
        "# first line\n",
        "export GTAGSLIBPATH=#{dirs.join(':')}\n"
      ]

      open('.envrc', 'w') { |f| f << lines.join }
      subject.run
      expect(open('.envrc', &:read)).to eq lines.join
    end
  end
end
