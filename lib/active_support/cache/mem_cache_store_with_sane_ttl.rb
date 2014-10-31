require 'active_support/cache'
require 'active_support/cache/mem_cache_store'
require 'active_support/cache/concerns/sane_memcached_ttl_helper'
require 'active_support/notifications'

module ActiveSupport
  module Cache
    class MemCacheStoreWithSaneTtl < MemCacheStore

      include ActiveSupport::Cache::Concerns::SaneMemcachedTtlHelper

      def initialize(*addresses)
        addresses = addresses.flatten
        options = addresses.extract_options!
        extract_large_default_ttl! options, [:expires_in]
        super addresses, options
      end

      def increment(name, amount = 1, options = nil)
        options = options || {}
        sanitize_ttl_options! options, [:expires_in], :expires_in
        super name, amount, options
      end

      def decrement(name, amount = 1, options = nil)
        options = options || {}
        sanitize_ttl_options! options, [:expires_in], :expires_in
        super name, amount, options
      end

      protected

      def write_entry(key, value, options)
        options = options || {}
        sanitize_ttl_options! options, [:expires_in], :expires_in
        super key, value, options
      end
    end
  end
end
