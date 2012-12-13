module GridVid 
  
  # Public:   Module level accessor for self
  # Set the api_key, api_sec, and base_url modifiable from external
  class << self
    attr_accessor :api_key, :api_sec, :base_url
  end 
  
  self.api_key  = nil
  self.api_sec  = nil
  self.base_url = 'https://cloud.cpusage.com/gridvid'
  
  def self.api_key
    @api_key || ENV['GRIDVID_KEY'] 
  end 

  def self.api_sec 
    @api_sec || ENV['GRIDVID_SECRET']
  end 

  def self.base_url
    @base_url
  end 
end 

require 'gridvid/group.rb'
require 'gridvid/job.rb'
require 'gridvid/net.rb'
