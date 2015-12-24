require 'yaml'
require 'jekyll-contentful-data-import/mappers'

module Jekyll
  module Contentful
    class Serializer
      attr_reader :entries, :config

      def initialize(entries, config = {})
        @entries = entries
        @config = config
      end

      def serialize
        entries.group_by { |entry| entry.content_type.id }.map do |content_type, entry_list|
          {
            content_type => entry_list.map do |entry|
              ::Jekyll::Contentful::Mappers::Base.mapper_for(entry, config).map
            end
          }
        end
      end

      def to_yaml
        YAML.dump(serialize)
      end
    end
  end
end
