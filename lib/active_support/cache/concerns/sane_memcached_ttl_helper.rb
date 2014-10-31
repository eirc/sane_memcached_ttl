require 'active_support/concern'

module ActiveSupport
  module Cache
    module Concerns
      module SaneMemcachedTtlHelper
        extend ActiveSupport::Concern
        include SaneMemcachedTtl::Utils

        included do
          attr_accessor :large_default_ttl
        end

        def extract_large_default_ttl!(options, insane_options)
          ttl = options[insane_options.find { |option| options[option] != nil }]

          if ttl.present? && is_large_ttl?(ttl)
            insane_options.each { |option| options.delete option }
            self.large_default_ttl = ttl
          end
        end

        def sanitize_ttl_options!(options, insane_options, default_option)
          ttl = options[insane_options.find { |option| options[option] != nil }]

          insane_options.each { |option| options.delete(option) }
          options[default_option] = sanitize_ttl(ttl || large_default_ttl)
        end
      end
    end
  end
end
