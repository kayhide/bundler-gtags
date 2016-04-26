# Bundler::Gtags

GNU Global (gtags) utility.

`bundler-gtags` command creates gtags for all bundled gems.
And also manages direnv settings exporting GTAGSLIBPATH so that editors can tag-jump
directly to any gems source code from the bundler application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bundler-gtags'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bundler-gtags

## Usage

To use tag-jump functionality to the utmost extent,
3 things are needed before go to your project.

**First**, [GNU Global](https://www.gnu.org/software/global/) is required.

Pymgments option is recommended.

On OSX:

    $ install global --with-ctags --with-pygments

**Next**, `direnv` command is required.

Go and follow the install instruction of
[direnv](https://github.com/direnv/direnv).

**And lastly**, your editor would need some setting.

On Emacs, `projectile-direnv` package works nicely.

```lisp
(use-package projectile-direnv
  :commands (projectile-direnv-export-variables)
  :init
  (add-hook 'projectile-mode-hook 'projectile-direnv-export-variables)
  )
```


Now, you are ready to generate gtags for your project's gems.

Go to your project root dir (there must be a Gemfile), and hit:

    $ bundler-gtags

After some time, GTAGS files are created at the every gem root dir.

And also `.envrc` file, which is direnv settings file, is to be at your project root dir.

If you are already using direnv and having `.envrc` file,
`bundler-gtags` command will just append a line to the end of the existing one.

Note that `.envrc` should be excluded from git management, because it includes some system specific settings.
Putting it into the user-local `.gitignore` might be a good idea.
To do so:

    $ git config --global core.excludesfile ~/.gitignore
    $ echo .envrc >> ~/.gitignore


Thats it.
Finally, you are ready to jump around the codes of gems.
Enjoy code reading :)

## Thanks

Original idea came from here.
[Emacs での Rails 開発を GNU GLOBAL でだいぶ快適にする](http://qiita.com/5t111111/items/5e854f6047d187ea21c7)

Thanks for @5t111111

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec bundler-gtags` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kayhide/bundler-gtags. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

