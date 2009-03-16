class MemCacheStoreWithDeleteMatched < ActiveSupport::Cache::MemCacheStore
 
  module Common
    KEY = 'memcached_store_key_list'
  end
  
  def write(name, value, options = nil)
    key_list = get_key_list
    unless key_list.include?(name)
      key_list << name
      return false unless _write(Common::KEY, key_list.to_yaml, options)
    end
    
    _write(name, value, options)
  end
 
  def delete_matched(matcher, options = nil)
    keys_to_remove = []
    key_list = get_key_list
    key_list.each do |name|
      if name.match(matcher)
        return false unless delete(name, options)
        keys_to_remove << name
      end
    end
    
    key_list -= keys_to_remove
    
    _write(Common::KEY, key_list.to_yaml, options)
  end
  
  private
 
  def get_key_list
    begin
      YAML.load(read(Common::KEY))
    rescue TypeError
      []
    end
  end
  
  def _write(key, value, options = nil)
    method = options && options[:unless_exist] ? :add : :set
    response = @data.send(method, key, value, expires_in(options), raw?(options))
    return true if response.nil?
    response == Response::STORED
  rescue MemCache::MemCacheError => e
    logger.error("MemCacheError (#{e}): #{e.message}")
    false
  end
end
