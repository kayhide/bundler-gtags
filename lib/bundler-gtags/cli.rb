require 'bundler'
require 'thor'

require 'bundler-gtags'
require 'bundler-gtags/utils'

module Bundler::Gtags
  class CLI < Thor
    include Thor::Actions

    default_task :gtags

    desc 'gtags', 'Create gtags and manage direnv settings'
    method_option :gtagslabel, type: :string, default: 'pygments'
    long_desc <<-D
      Creates GNU Global (gtags) for all bundled gems. And also manages direnv
      settings for current project exporting GTAGSLIBPATH with project path and
      all gem paths.
    D
    def gtags(*args)
      require 'bundler-gtags/cli/gtags'
      Gtags.new(options, args).run
    end
  end
end
