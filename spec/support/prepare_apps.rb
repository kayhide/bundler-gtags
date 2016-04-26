require "pathname"

Module.new do
  def prepare_apps
    Dir[fixtures_dir.join('*')].each do |dir|
      prepare_app dir
    end
  end

  def prepare_app src
    dst = prepared_apps_dir.join File.basename(src)
    return if Dir.exist? dst

    say :prepare, dst, :blue
    FileUtils.mkdir_p dst.dirname
    FileUtils.cp_r src, dst.dirname
    Dir.chdir dst do
      puts `bundle`
    end
  end

  RSpec.configure do |config|
    config.include self

    config.before :all do
      prepare_apps
    end
  end
end
