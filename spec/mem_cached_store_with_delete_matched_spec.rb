require File.join(File.dirname(__FILE__), 'test_helper')

describe "MemcachedStoreWithDeleteMatched" do
  
  before(:each) do
    @memcache = MemCacheStoreWithDeleteMatched.new('localhost:11211', :readonly => false)
    @memcache.clear
  end
  
  it "should write key to cache and also write this key to list of keys" do
    @memcache.write('car', 'black').should be_true
    @memcache.read(MemCacheStoreWithDeleteMatched::Common::KEY).should == ['car'].to_yaml
    @memcache.read('car').should == 'black'
  end
  
  it "should delete keys from cache based on matcher" do
    @memcache.write('car', 'black').should be_true
    @memcache.write('car2', 'white').should be_true
    @memcache.write('cra', 'do not remove').should be_true
    @memcache.read(MemCacheStoreWithDeleteMatched::Common::KEY).should == ['car', 'car2', 'cra'].to_yaml
    
    @memcache.delete_matched(/car/).should == true
    @memcache.read(MemCacheStoreWithDeleteMatched::Common::KEY).should == ['cra'].to_yaml
    @memcache.read('car').should be_nil
    @memcache.read('car2').should be_nil
    @memcache.read('cra').should == 'do not remove'
  end
  
end