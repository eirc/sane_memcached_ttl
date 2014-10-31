require 'spec_helper'
require 'active_support/cache/dalli_store_with_sane_ttl'

module ActiveSupport::Cache
  describe 'dalli stores' do
    let(:large_ttl) { 6 * 30 * 24 * 60 * 60 }

    before do
      # Silence all logging to make an initial check on whether server is up
      Dalli.logger.level = Logger::UNKNOWN
      store = ActiveSupport::Cache.lookup_store :dalli_store,
                                                CACHE_SETTINGS[:dalli]

      if store.stats.values.all? { |value| value == nil }
        skip 'Cannot connect to Memcached server, skipping dalli stores integration specs.'
      end

      # Silence connection info messages from dalli
      Dalli.logger.level = Logger::WARN
    end

    describe 'with connection ttls' do
      it 'dalli_store_with_sane_ttl does store keys with large connection expires_in' do
        store = ActiveSupport::Cache.lookup_store :dalli_store_with_sane_ttl,
                                                  CACHE_SETTINGS[:dalli],
                                                  :expires_in => large_ttl

        store.read('key').must_be_nil
        store.write 'key', 'value'
        store.read('key').must_equal 'value'
        store.delete 'key'
      end

      it 'dalli_store does not store keys with large connection expires_in' do
        store = ActiveSupport::Cache.lookup_store :dalli_store,
                                                  CACHE_SETTINGS[:dalli],
                                                  :expires_in => large_ttl

        store.read('key').must_be_nil
        store.write 'key', 'value'
        store.read('key').must_be_nil
        store.delete 'key'
      end
    end

    describe 'with ttls on write' do
      it 'dalli_store_with_sane_ttl does store keys with large expires_in' do
        store = ActiveSupport::Cache.lookup_store :dalli_store_with_sane_ttl,
                                                  CACHE_SETTINGS[:dalli]

        store.read('key').must_be_nil
        store.write 'key', 'value', :expires_in => large_ttl
        store.read('key').must_equal 'value'
        store.delete 'key'
      end

      it 'dalli_store does not store keys with large expires_in' do
        store = ActiveSupport::Cache.lookup_store :dalli_store,
                                                  CACHE_SETTINGS[:dalli]

        store.read('key').must_be_nil
        store.write 'key', 'value', :expires_in => large_ttl
        store.read('key').must_be_nil
        store.delete 'key'
      end
    end
  end
end
