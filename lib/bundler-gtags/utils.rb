require 'colored'

module Bundler::Gtags
  module Utils
    def say status, message, color
      puts [
        Colored.colorize('%12s' % status, foreground: color),
        message
      ].join(' ')
    end
  end
end

Object.include Bundler::Gtags::Utils
