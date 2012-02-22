# encoding: utf-8
require 'guard'
require 'guard/guard'
#require 'librarian'

module Guard
  class Librarian < Guard
    autoload :Notifier, 'guard/librarian/notifier'

    def initialize(watchers = [], options = {})
      super
      options[:run_on_start] = true unless options[:run_on_start] == false
      options[:notify] = true if options[:notify].nil?
    end

    def start
      refresh_bundle if options[:run_on_start]
    end

    def reload
      start
    end

    def run_on_change(paths = [])
      #puts "paths=#{paths.join(' ')}"
      dirs = paths.map {|_| File.dirname(_) }
      refresh_bundle(dirs)
    end

    private

    def notify?
      !!options[:notify]
    end

    def refresh_bundle(dirs = ['.'])
      if bundle_need_refresh?
        UI.info 'Refresh cookbooks', :reset => true
        start_at = Time.now
        dirs.each do |dir|
          Dir.chdir(dir) do
            #puts "Dir.getwd=#{Dir.getwd.inspect}"
            @result = system("librarian-chef install#{options[:cli] ? " #{options[:cli]}" : ''}")
          end
        end
        Notifier::notify(@result, Time.now - start_at) if notify?
        @result
      else
        UI.info 'Cookbooks already up-to-date', :reset => true
        Notifier::notify('up-to-date', nil) if notify?
        true
      end
    end

    def bundle_need_refresh?
      true
     #::Bundler.with_clean_env do
     #  `bundle check`
     #end
     #$? == 0 ? false : true
    end

  end
end
