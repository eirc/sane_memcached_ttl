require 'minitest/spec'
require 'minitest/autorun'

require 'sane_memcached_ttl'

CACHE_SETTINGS = {
    :couchbase => {},
    :dalli => [],
    :mem_cache => []
}
