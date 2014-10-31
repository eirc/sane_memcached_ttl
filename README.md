# SaneMemcachedTtl

[![Build Status](https://travis-ci.org/eirc/sane_memcached_ttl.svg?branch=v0.0.1)](https://travis-ci.org/eirc/sane_memcached_ttl)
[![Code Climate](https://codeclimate.com/github/eirc/sane_memcached_ttl/badges/gpa.svg)](https://codeclimate.com/github/eirc/sane_memcached_ttl)
[![Gem Version](https://badge.fury.io/rb/sane_memcached_ttl.svg)](http://badge.fury.io/rb/sane_memcached_ttl)
[![Dependency Status](https://gemnasium.com/eirc/sane_memcached_ttl.svg)](https://gemnasium.com/eirc/sane_memcached_ttl)
![Gem Downloads](http://ruby-gem-downloads-badge.herokuapp.com/sane_memcached_ttl)

Work around memcached's [feature](https://code.google.com/p/memcached/wiki/NewProgramming#Expiration) of treating expiration times larger than one month as timestamps for Rails cache stores.

This is a memcached documented behaviour:

* Store a key with expiration time of 10 seconds
* Retrieve key ~> you get it
* Wait 10 seconds
* Retrieve key ~> you don't get it

makes sense... but:

* Store a key with expiration time of 3.000.000 seconds (about 35 days)
* Retrieve key ~> you **don't** get it

3.000.000 is treated as timestamp, so the key expired at 1970-02-04 17:20:00 (3.000.000 seconds after the UNIX epoch). So when you want to store something with an expiration time larger than a month you have to convert the expiration time to a proper timestamp. This is annoying and it even becomes impossible when you want to set default expiration times on stores.

This gem provides additional cache stores, subclasses of the original ones altering this behaviour for sanity.

Supported cache stores: couchbase_store, dalli_store, mem_cache_store.

## Dalli note

The dalli store actually fixed this on version 2.7.1 but it's kinda debated ([issue #436](https://github.com/mperham/dalli/issues/436)) on whether this should stay in as it's a documented memcached "feature" and clients should probably be not alter to these things.

So **don't** use this if your dalli gem version is >= 2.7.1.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sane_memcached_ttl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sane_memcached_ttl

## Usage

When defining a Rails cache store like:

```ruby
config.cache_store = :mem_cache_store, "cache-1.example.com", "cache-2.example.com"
```

just change to:

```ruby
config.cache_store = :mem_cache_store_with_sane_ttl, "cache-1.example.com", "cache-2.example.com"
```

Same for all supported stores:

| Original store    | Sane store                        |
| ----------------- | --------------------------------- |
| `mem_cache_store` | `mem_cache_store_with_sane_ttl`   |
| `dalli_store`     | `dalli_store_store_with_sane_ttl` |
| `couchbase_store` | `couchbase_store_with_sane_ttl`   |

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sane_memcached_ttl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
