# -*- encoding: utf-8 -*-
module Shows

    class Show

        attr_reader :id, :name, :summary

        def initialize(id, name, summary)
            @id = id
            @name = name
            @summary = summary
        end

        def self.find_by_name(name)
            # Devra retourner un objet Show grâce à l'API tvdb
        end

    end

end