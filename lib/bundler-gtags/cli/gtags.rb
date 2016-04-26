require 'colored'

module Bundler::Gtags
  class CLI::Gtags
    attr_reader :options, :args

    def initialize(options, args)
      @options = options
      @cmd = args.shift
      @args = args
    end

    def run
      generate_gtags
      update_envrc
    end

    def gtagslabel
      @options[:gtagslabel]
    end

    def gem_dirs
      @gem_dirs ||=
        `bundle show --paths`.lines.map(&:chomp).
        select { |dir| Dir.exist? dir }
    end

    def envrc
      '.envrc'
    end

    private

    def generate_gtags
      gem_dirs.select { |dir| Dir.exist? dir }.each do |dir|
        Dir.chdir dir do
          if File.exist? File.join(dir, 'GTAGS')
            say 'exist', File.basename(dir), :yellow
          else
            say 'gtags', File.basename(dir), :green
            `gtags --gtagslabel=#{gtagslabel}`
          end
        end
      end
    end

    def update_envrc
      original =
        if File.exist? envrc
          open(envrc) { |f| f.read }
        end

      paths = [Dir.pwd, *gem_dirs]
      new_line = "export GTAGSLIBPATH=#{paths.join(':')}\n"

      updated =
        if original
          replaced = false
          original.lines.inject([]) do |res, line|
            if line =~ /^export GTAGSLIBPATH=/
              if replaced
                res
              else
                replaced = true
                res << new_line
              end
            else
              res << line
            end
          end.join
        end

      if updated && !updated.include?(new_line)
        updated << "\n" if updated[-1] != "\n"
        updated << new_line
      end

      updated ||= new_line

      if original == updated
        say 'identical', '.envrc', :blue
      else
        open(envrc, 'w') do |f|
          if original
            say 'update', '.envrc', :magenta
          else
            say 'create', '.envrc', :green
          end
          f << updated
        end
        `direnv allow`
      end
    end
  end
end
