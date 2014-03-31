# -*- encoding: utf-8 -*-
module Shows

    module Provider

        @@provider = nil

        def self.set(provider)
            @@provider = provider
        end

        def self.shows_by_name(show_name)
            raise NotImplementedError.new if @@provider.nil? || !@@provider.respond_to?(:shows_by_name)

            @@provider.shows_by_name(show_name)
        end

    end

end