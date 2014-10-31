require 'active_support/cache'
require 'active_support/cache/couchbase_store'
require 'active_support/cache/concerns/sane_memcached_ttl_helper'

module ActiveSupport
  module Cache
    class CouchbaseStoreWithSaneTtl < CouchbaseStore

      include ActiveSupport::Cache::Concerns::SaneMemcachedTtlHelper

      def initialize(options = nil)
        options = options || {}
        extract_large_default_ttl! options, [:default_ttl, :expires_in]
        super options
      end

      def increment(name, amount = 1, options = nil)
        options = options || {}
        sanitize_ttl_options! options, [:ttl, :expires_in], :expires_in
        super name, amount, options
      end

      def decrement(name, amount = 1, options = nil)
        options = options || {}
        sanitize_ttl_options! options, [:ttl, :expires_in], :expires_in
        super name, amount, options
      end

      protected

      def write_entry(key, value, options)
        options = options || {}
        sanitize_ttl_options! options, [:ttl, :expires_in], :expires_in
        super key, value, options
      end
    end
  end
end
