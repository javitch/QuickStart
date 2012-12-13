
module GridVid 
  class SubmitException < Exception
    def initialize(reason)
      @reason = reason 
    end 
  end 
  
  require 'net/http'
  require 'net/https'
  require 'rubygems'
  require 'json' 
  
  module_function
  def impl_exit_code_check(res)
    
  end 
  

  module_function
  def impl_submit_post(url, json)
    uri  = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true 
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE 

    req = Net::HTTP::Post.new(uri.request_uri,
                initheader = {'Content-Type'  => 'application/json'}
                )
    
    req.body = JSON.generate(json) 

    http.start {|http| http.request(req)}
  end 
 

  module_function
  def impl_submit_get(url, json)
    uri  = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true 
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE 

    req = Net::HTTP::Get.new(uri.request_uri,
                initheader = {'Content-Type'  => 'application/json'}
                )

    req.body = JSON.generate(json)
    
    http.start {|http| http.request(req)}
  end 

  
  module_function
  def submit(job)
    raise 'job query must be of type hash' unless job.kind_of? Hash 
    
    res = self.impl_submit_post(self.base_url, job) 
    self.impl_exit_code_check(res) 
    
    ret = JSON.parse(res.body)
    
    ret['jobid'] 
  end


  module_function
  def query(job_query)
    raise 'job query must be of type hash' unless job_query.kind_of? Hash 
  
    res = impl_submit_get(self.base_url + '/query', job_query)
    self.impl_exit_code_check(res) 

    JSON.parse(res.body)
  end
  
  
  module_function
  def discover(discover_query)
    res = impl_submit_get(self.base_url + '/discover', discover_query)
    self.impl_exit_code_check(res) 
    
    JSON.parse(res.body)
  end 

end 
