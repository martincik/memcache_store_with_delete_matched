$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
gem 'rspec'

require 'spec'
require 'rubygems'
require 'active_record'
require 'active_record/fixtures'
require 'pp'
require 'ostruct'
require 'ruby-debug'
require File.dirname(__FILE__) + '/../init.rb'

# Fix the OpenStruct warning with id
OpenStruct.__send__(:define_method, :id) { @table[:id] }

class Array
  def ids
    collect &:id
  end
end

Spec::Runner.configure do |config|
end