require 'spec_helper'
require 'mocha/setup'
require 'active_support/cache/couchbase_store_with_sane_ttl'

module ActiveSupport::Cache
  describe CouchbaseStoreWithSaneTtl do
    let (:small_ttl) { 7 * 24 * 60 * 60 }
    let (:large_ttl) { 6 * 30 * 24 * 60 * 60 }

    describe '#initialize' do
      it 'should remove from options and store large default_ttl value' do
        Couchbase::Bucket.expects(:new).with do |options|
          options[:default_ttl].must_be_nil
          options[:expires_in].must_be_nil
        end

        store = ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl,
                                                  :default_ttl => large_ttl

        store.large_default_ttl.must_equal large_ttl
      end

      it 'should remove from options and store large expires_in value' do
        Couchbase::Bucket.expects(:new).with do |options|
          options[:default_ttl].must_be_nil
          options[:expires_in].must_be_nil
        end

        store = ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl,
                                                  :expires_in => large_ttl

        store.large_default_ttl.must_equal large_ttl
      end

      it 'should not remove from options or store small default_ttl value' do
        Couchbase::Bucket.expects(:new).with do |options|
          options[:default_ttl].must_equal small_ttl
          options[:expires_in].must_be_nil
        end

        store = ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl,
                                                  :default_ttl => small_ttl

        store.large_default_ttl.must_be_nil
      end

      it 'should not remove or store small expires_in value' do
        Couchbase::Bucket.expects(:new).with do |options|
          options[:default_ttl].must_equal small_ttl
          options[:expires_in].must_be_nil
        end

        store = ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl,
                                                  :expires_in => small_ttl

        store.large_default_ttl.must_be_nil
      end
    end

    describe '#increment' do
      describe 'with no default tll' do
        let(:bucket_mock) { mock }
        subject do
          Couchbase::Bucket.expects(:new).returns(bucket_mock)
          ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl
        end

        it 'should convert ttl to timestamp when set to large value' do
          bucket_mock.expects(:incr).with do |key, amount, options|
            options[:ttl].must_equal Time.now.utc.to_i + large_ttl
          end
          subject.increment 'key', 1, :expires_in => large_ttl
        end

        it 'should keep ttl intact when set to small value' do
          bucket_mock.expects(:incr).with do |key, amount, options|
            options[:ttl].must_equal small_ttl
          end
          subject.increment 'key', 1, :expires_in => small_ttl
        end

        it 'should leave ttl nil when not set' do
          bucket_mock.expects(:incr).with do |key, amount, options|
            options[:ttl].must_be_nil
          end
          subject.increment 'key', 1
        end
      end

      describe 'with large default tll' do
        let(:bucket_mock) { mock }
        subject do
          Couchbase::Bucket.expects(:new).returns(bucket_mock)
          ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl,
                                            :expires_in => large_ttl
        end

        it 'should convert ttl to timestamp when set to large value' do
          bucket_mock.expects(:incr).with do |key, amount, options|
            options[:ttl].must_equal Time.now.utc.to_i + large_ttl
          end
          subject.increment 'key', 1, :expires_in => large_ttl
        end

        it 'should keep ttl intact when set to small value' do
          bucket_mock.expects(:incr).with do |key, amount, options|
            options[:ttl].must_equal small_ttl
          end
          subject.increment 'key', 1, :expires_in => small_ttl
        end

        it 'should calculate from default ttl when not set' do
          bucket_mock.expects(:incr).with do |key, amount, options|
            (options[:ttl]).must_equal Time.now.utc.to_i + large_ttl
          end
          subject.increment 'key', 1
        end
      end

      describe 'with small default tll' do
        let(:bucket_mock) { mock }
        subject do
          Couchbase::Bucket.expects(:new).returns(bucket_mock)
          ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl,
                                            :default_ttl => small_ttl
        end

        it 'should convert ttl to timestamp when set to large value' do
          bucket_mock.expects(:incr).with do |key, amount, options|
            options[:ttl].must_equal Time.now.utc.to_i + large_ttl
          end
          subject.increment 'key', 1, :expires_in => large_ttl
        end

        it 'should keep ttl intact when set to small value' do
          bucket_mock.expects(:incr).with do |key, amount, options|
            options[:ttl].must_equal small_ttl
          end
          subject.increment 'key', 1, :expires_in => small_ttl
        end

        it 'should leave ttl nil when not set' do
          bucket_mock.expects(:incr).with do |key, amount, options|
            options[:ttl].must_be_nil
          end
          subject.increment 'key', 1
        end
      end
    end

    describe '#decrement' do
      describe 'with no default tll' do
        let(:bucket_mock) { mock }
        subject do
          Couchbase::Bucket.expects(:new).returns(bucket_mock)
          ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl
        end

        it 'should convert ttl to timestamp when set to large value' do
          bucket_mock.expects(:decr).with do |key, amount, options|
            options[:ttl].must_equal Time.now.utc.to_i + large_ttl
          end
          subject.decrement 'key', 1, :expires_in => large_ttl
        end

        it 'should keep ttl intact when set to small value' do
          bucket_mock.expects(:decr).with do |key, amount, options|
            options[:ttl].must_equal small_ttl
          end
          subject.decrement 'key', 1, :expires_in => small_ttl
        end

        it 'should leave ttl nil when not set' do
          bucket_mock.expects(:decr).with do |key, amount, options|
            options[:ttl].must_be_nil
          end
          subject.decrement 'key', 1
        end
      end

      describe 'with large default tll' do
        let(:bucket_mock) { mock }
        subject do
          Couchbase::Bucket.expects(:new).returns(bucket_mock)
          ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl,
                                            :default_ttl => large_ttl
        end

        it 'should convert ttl to timestamp when set to large value' do
          bucket_mock.expects(:decr).with do |key, amount, options|
            options[:ttl].must_equal Time.now.utc.to_i + large_ttl
          end
          subject.decrement 'key', 1, :expires_in => large_ttl
        end

        it 'should keep ttl intact when set to small value' do
          bucket_mock.expects(:decr).with do |key, amount, options|
            options[:ttl].must_equal small_ttl
          end
          subject.decrement 'key', 1, :expires_in => small_ttl
        end

        it 'should calculate from default ttl when not set' do
          bucket_mock.expects(:decr).with do |key, amount, options|
            options[:ttl].must_equal Time.now.utc.to_i + large_ttl
          end
          subject.decrement 'key', 1
        end
      end

      describe 'with small default tll' do
        let(:bucket_mock) { mock }
        subject do
          Couchbase::Bucket.expects(:new).returns(bucket_mock)
          ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl,
                                            :default_ttl => small_ttl
        end

        it 'should convert ttl to timestamp when set to large value' do
          bucket_mock.expects(:decr).with do |key, amount, options|
            options[:ttl].must_equal Time.now.utc.to_i + large_ttl
          end
          subject.decrement 'key', 1, :expires_in => large_ttl
        end

        it 'should keep ttl intact when set to small value' do
          bucket_mock.expects(:decr).with do |key, amount, options|
            options[:ttl].must_equal small_ttl
          end
          subject.decrement 'key', 1, :expires_in => small_ttl
        end

        it 'should leave ttl nil when not set' do
          bucket_mock.expects(:decr).with do |key, amount, options|
            options[:ttl].must_be_nil
          end
          subject.decrement 'key', 1
        end
      end
    end

    describe '#write' do
      describe 'with no default tll' do
        let(:bucket_mock) { mock }
        subject do
          Couchbase::Bucket.expects(:new).returns(bucket_mock)
          ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl
        end

        it 'should convert ttl to timestamp when set to large value' do
          bucket_mock.expects(:set).with do |key, value, options|
            options[:ttl].must_equal Time.now.utc.to_i + large_ttl
          end
          subject.write 'key', 'value', :expires_in => large_ttl
        end

        it 'should keep ttl intact when set to small value' do
          bucket_mock.expects(:set).with do |key, value, options|
            options[:ttl].must_equal small_ttl
          end
          subject.write 'key', 'value', :expires_in => small_ttl
        end

        it 'should leave ttl nil when not set' do
          bucket_mock.expects(:set).with do |key, value, options|
            options[:ttl].must_be_nil
          end
          subject.write 'key', 'value'
        end
      end

      describe 'with large default tll' do
        let(:bucket_mock) { mock }
        subject do
          Couchbase::Bucket.expects(:new).returns(bucket_mock)
          ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl,
                                            :default_ttl => large_ttl
        end

        it 'should convert ttl to timestamp when set to large value' do
          bucket_mock.expects(:set).with do |key, value, options|
            options[:ttl].must_equal Time.now.utc.to_i + large_ttl
          end
          subject.write 'key', 'value', :expires_in => large_ttl
        end

        it 'should keep ttl intact when set to small value' do
          bucket_mock.expects(:set).with do |key, value, options|
            options[:ttl].must_equal small_ttl
          end
          subject.write 'key', 'value', :expires_in => small_ttl
        end

        it 'should calculate from default ttl when not set' do
          bucket_mock.expects(:set).with do |key, value, options|
            options[:ttl].must_equal Time.now.utc.to_i + large_ttl
          end
          subject.write 'key', 'value'
        end
      end

      describe 'with small default tll' do
        let(:bucket_mock) { mock }
        subject do
          Couchbase::Bucket.expects(:new).returns(bucket_mock)
          ActiveSupport::Cache.lookup_store :couchbase_store_with_sane_ttl,
                                            :default_ttl => small_ttl
        end

        it 'should convert ttl to timestamp when set to large value' do
          bucket_mock.expects(:set).with do |key, value, options|
            options[:ttl].must_equal Time.now.utc.to_i + large_ttl
          end
          subject.write 'key', 'value', :expires_in => large_ttl
        end

        it 'should keep ttl intact when set to small value' do
          bucket_mock.expects(:set).with do |key, value, options|
            options[:ttl].must_equal small_ttl
          end
          subject.write 'key', 'value', :expires_in => small_ttl
        end

        it 'should leave ttl nil when not set' do
          bucket_mock.expects(:set).with do |key, value, options|
            options[:ttl].must_be_nil
          end
          subject.write 'key', 'value'
        end
      end
    end
  end
end
