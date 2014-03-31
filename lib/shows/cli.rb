# -*- encoding: utf-8 -*-
require 'shows/version'
require 'shows/providers/tvdb'

module Shows

    def self.execute
        Provider::set(TVDB)

        begin
            show = Show.find_by_name(ARGV.first)
            puts(show.summary)
        rescue Exception => e
            puts(e.message)
        end
    end

end