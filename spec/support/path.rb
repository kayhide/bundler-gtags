require "pathname"

Module.new do
  def root
    @root ||= Pathname.new(File.expand_path("../../..", __FILE__))
  end

  def tmp_dir
    root.join("tmp")
  end

  def fixtures_dir
    root.join('spec/fixtures')
  end

  def prepared_apps_dir
    tmp_dir.join('prepared_apps')
  end

  def apps_dir
    tmp_dir.join('apps')
  end

  RSpec.configure do |config|
    config.include self
    config.extend self
  end
end
