require 'spec_helper'
require 'active_support/cache'

module ActiveSupport::Cache
  describe 'couchbase stores' do
    let(:large_ttl) { 6 * 30 * 24 * 60 * 60 }

    before do
      begin
        ActiveSupport::Cache.lookup_store :couchbase_store,
                                          CACHE_SETTINGS[:couchbase]
      rescue
        skip 'Cannot connect to Couchbase server, skipping integration tests.'
      end
    end

    describe 'with connection ttls' do
      it 'couchbase_store_with_sane_ttl does store keys with large connection default_ttl' do
        store = ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl,
                                                  CACHE_SETTINGS[:couchbase].merge(:default_ttl => large_ttl)

        store.read('key').must_be_nil
        store.write 'key', 'value'
        store.read('key').must_equal 'value'
        store.delete 'key'
      end

      it 'couchbase_store does not store keys with large connection default_ttl' do
        store = ActiveSupport::Cache.lookup_store :couchbase_store,
                                                  CACHE_SETTINGS[:couchbase].merge(:default_ttl => large_ttl)

        store.read('key').must_be_nil
        store.write 'key', 'value'
        store.read('key').must_be_nil
        store.delete 'key'
      end

      it 'couchbase_store_with_sane_ttl does store keys with large connection expires_in' do
        store = ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl,
                                                  CACHE_SETTINGS[:couchbase].merge(:expires_in => large_ttl)

        store.read('key').must_be_nil
        store.write 'key', 'value'
        store.read('key').must_equal 'value'
        store.delete 'key'
      end

      it 'couchbase_store does not store keys with large connection expires_in' do
        store = ActiveSupport::Cache.lookup_store :couchbase_store,
                                                  CACHE_SETTINGS[:couchbase].merge(:expires_in => large_ttl)

        store.read('key').must_be_nil
        store.write 'key', 'value'
        store.read('key').must_be_nil
        store.delete 'key'
      end
    end

    describe 'with ttls on write' do
      it 'couchbase_store_with_sane_ttl does store keys with large expires_in' do
        store = ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl,
                                                  CACHE_SETTINGS[:couchbase]

        store.read('key').must_be_nil
        store.write 'key', 'value', :expires_in => large_ttl
        store.read('key').must_equal 'value'
        store.delete 'key'
      end

      it 'couchbase_store does not store keys with large expires_in' do
        store = ActiveSupport::Cache.lookup_store :couchbase_store,
                                                  CACHE_SETTINGS[:couchbase]

        store.read('key').must_be_nil
        store.write 'key', 'value', :expires_in => large_ttl
        store.read('key').must_be_nil
        store.delete 'key'
      end

      it 'couchbase_store_with_sane_ttl does store keys with large ttl' do
        store = ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl,
                                                  CACHE_SETTINGS[:couchbase]

        store.read('key').must_be_nil
        store.write 'key', 'value', :ttl => large_ttl
        store.read('key').must_equal 'value'
        store.delete 'key'
      end

      it 'couchbase_store does not store keys with large ttl' do
        store = ActiveSupport::Cache.lookup_store :couchbase_store,
                                                  CACHE_SETTINGS[:couchbase]

        store.read('key').must_be_nil
        store.write 'key', 'value', :ttl => large_ttl
        store.read('key').must_be_nil
        store.delete 'key'
      end
    end
  end
end
