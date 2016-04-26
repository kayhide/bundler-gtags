require 'open3'

Module.new do
  def bundle_gtags options = {}
    expect_err = options.delete(:expect_err)
    options["no-color"] = true unless options.key?("no-color")

    bundle_bin = File.expand_path("../../../exe/bundle-gtags", __FILE__)

    env = (options.delete(:env) || {}).map {|k, v| "#{k}='#{v}'" }.join(" ")
    args = options.map do |k, v|
      v == true ? " --#{k}" : " --#{k} #{v}" if v
    end.join

    cmd = "#{env} #{Gem.ruby} #{bundle_bin} #{cmd}#{args}"
    sys_exec(cmd, expect_err)
  end

  def bundle(cmd, options = {})
    bundle_bin = File.expand_path("../../../exe/bundle", __FILE__)

    requires = options.delete(:requires) || []
    requires << File.expand_path("../fakeweb/" + options.delete(:fakeweb) + ".rb", __FILE__) if options.key?(:fakeweb)
    requires << File.expand_path("../artifice/" + options.delete(:artifice) + ".rb", __FILE__) if options.key?(:artifice)
    requires << "support/hax"
    requires_str = requires.map {|r| "-r#{r}" }.join(" ")

    env = (options.delete(:env) || {}).map {|k, v| "#{k}='#{v}'" }.join(" ")
    args = options.map do |k, v|
      v == true ? " --#{k}" : " --#{k} #{v}" if v
    end.join

    cmd = "#{env} #{sudo} #{Gem.ruby} -I#{lib}:#{spec} #{requires_str} #{bundle_bin} #{cmd}#{args}"
    sys_exec(cmd, expect_err) {|i| yield i if block_given? }
  end

  def sys_exec(cmd, expect_err = false)
    Open3.popen3(cmd.to_s) do |stdin, stdout, stderr, wait_thr|
      yield stdin if block_given?
      stdin.close

      @out = Thread.new { stdout.read }.value.strip
      @err = Thread.new { stderr.read }.value.strip
      @exitstatus = wait_thr && wait_thr.value.exitstatus
    end

    puts @err unless expect_err || @err.empty? || !$show_err
    @out
  end

  RSpec.configure do |config|
    config.include self
  end
end
