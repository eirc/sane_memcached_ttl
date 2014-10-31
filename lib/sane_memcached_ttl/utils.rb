module SaneMemcachedTtl
  module Utils
    MEMCACHED_MAX_TTL = 30 * 24 * 60 * 60 # 30 days

    def sanitize_ttl(ttl)
      is_large_ttl?(ttl) ? ttl_to_timestamp(ttl) : ttl
    end

    def is_large_ttl?(ttl)
      ttl.to_i > MEMCACHED_MAX_TTL
    end

    def ttl_to_timestamp(ttl)
      Time.now.utc.to_i + ttl.to_i
    end
  end
end
