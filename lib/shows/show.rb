# -*- encoding: utf-8 -*-
module Shows

    class NoShowFound < StandardError
    end

    class MultipleShowsFound < StandardError
    end

    class Show

        attr_reader :id, :name, :summary

        def initialize(id, name, summary)
            @id = id
            @name = name
            @summary = summary
        end

        def self.find_by_name(name)
            shows = Provider::shows_by_name(name)

            raise NoShowFound.new('No show found for "%s"' % name) if shows.empty?
            raise MultipleShowsFound.new('Multiple shows found for "%s"' % name) if shows.length > 1

            shows.first
        end

    end

end