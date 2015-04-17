require 'thread'
require 'fast_cache/cache'

class FastCache::CacheThreadSafe < FastCache::Cache
  include MonitorMixin
  def initialize(*args)
    super(*args)
  end

  def self.synchronize(*methods)
    methods.each do |method|
      define_method method do |*args, &blk|
        synchronize do
          super(*args,&blk)
        end
      end
    end
  end

  synchronize :fetch, :[], :[]=, :delete, :empty?, :clear, :count, :each, :expire!, :inspect
end