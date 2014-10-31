require 'spec_helper'
require 'active_support/cache'
require 'dalli'

module ActiveSupport::Cache
  describe 'mem cache stores' do
    let(:large_ttl) { 6 * 30 * 24 * 60 * 60 }

    before do
      # Silence all logging to make an initial check on whether server is up (mem_cache_store is backed by a dalli client)
      Dalli.logger.level = Logger::UNKNOWN
      store = ActiveSupport::Cache.lookup_store :mem_cache_store,
                                        CACHE_SETTINGS[:mem_cache]

      if store.stats.values.all? { |value| value == nil }
        skip 'Cannot connect to Memcached server, skipping mem cache stores integration specs.'
      end

      # Silence connection info messages
      Dalli.logger.level = Logger::WARN
    end

    describe 'with connection ttls' do
      it 'mem_cache_store_with_sane_ttl does store keys with large connection expires_in' do
        store = ActiveSupport::Cache.lookup_store :mem_cache_store_with_sane_ttl,
                                                  CACHE_SETTINGS[:mem_cache],
                                                  :expires_in => large_ttl

        store.read('key').must_be_nil
        store.write 'key', 'value'
        store.read('key').must_equal 'value'
        store.delete 'key'
      end

      it 'mem_cache_store does not store keys with large connection expires_in' do
        store = ActiveSupport::Cache.lookup_store :mem_cache_store,
                                                  CACHE_SETTINGS[:mem_cache],
                                                  :expires_in => large_ttl

        store.read('key').must_be_nil
        store.write 'key', 'value'
        store.read('key').must_be_nil
        store.delete 'key'
      end
    end

    describe 'with ttls on write' do
      it 'mem_cache_store_with_sane_ttl does store keys with large expires_in' do
        store = ActiveSupport::Cache.lookup_store :mem_cache_store_with_sane_ttl,
                                                  CACHE_SETTINGS[:mem_cache]

        store.read('key').must_be_nil
        store.write 'key', 'value', :expires_in => large_ttl
        store.read('key').must_equal 'value'
        store.delete 'key'
      end

      it 'mem_cache_store does not store keys with large expires_in' do
        store = ActiveSupport::Cache.lookup_store :mem_cache_store,
                                                  CACHE_SETTINGS[:mem_cache]

        store.read('key').must_be_nil
        store.write 'key', 'value', :expires_in => large_ttl
        store.read('key').must_be_nil
        store.delete 'key'
      end
    end
  end
end
