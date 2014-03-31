# -*- encoding: utf-8 -*-
require 'cgi'
require 'uri'
require 'net/http'
require 'rexml/document'

module Shows

    module TVDB

        # L'URL de base de l'API (peut être remplacée par un mirroir)
        BASE_URL = "http://thetvdb.com"
        # Le path pour l'API en question
        API_URL = BASE_URL + "/api"

        def self.shows_by_name(show_name)

            # On lève une exception si aucun nom n'est donné
            raise ArgumentError.new('show_name could not be nil') if show_name.nil?

            shows = []

            # On commence par créer notre URI
            uri = URI.parse('%s/GetSeries.php?seriesname=%s' % [API_URL, CGI.escape(show_name)])

            # Ensuite on effectue une requête de manière à récupérer le XML
            res = Net::HTTP.get_response(uri)

            # Si la requête a bien été exécutée
            if res.code == '200'
                # On construit le document xml
                doc = REXML::Document.new(res.body)

                # Et on parcourt tous les noeuds qui nous intéressent
                doc.elements.each('Data/Series') do |s_node|

                    id = s_node.elements['id'] && s_node.elements['id'].text
                    name = s_node.elements['SeriesName'] && s_node.elements['SeriesName'].text
                    overview = s_node.elements['Overview'] && s_node.elements['Overview'].text

                    # Pour chaque série, on crée un object Show
                    shows << Show.new(id, name, overview)
                end
            end

            shows
        end

    end

end