Module.new do
  def use_app app_name = 'rake_app'
    let(:app_name) { app_name }

    let(:app_dir) { apps_dir.join(app_name) }

    before do
      FileUtils.mkdir_p(app_dir.dirname)
      FileUtils.cp_r(prepared_apps_dir.join(app_name), app_dir.dirname)
      Dir.chdir app_dir
    end

    after do
      Dir.chdir root
      FileUtils.rm_rf app_dir
    end
  end

  RSpec.configure do |config|
    config.extend self
  end
end
