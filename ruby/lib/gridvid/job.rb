
require 'json' 

module GridVid
  require 'gridvid/net'

  class Job 
    attr_accessor :jobid 


    def initialize(job_data, iput, oput)
      raise 'input must be hash map'       unless iput.kind_of?     Hash
      raise 'output must be hash map'      unless oput.kind_of?     Hash
      raise 'JobData must be of type hash' unless job_data.kind_of? Hash
      
      self.jobid = nil

      @_submit = {
        :key    => GridVid.api_key,
        :secret => GridVid.api_sec,
        :input  => iput,
        :output => oput
      }.merge(job_data)
    end 


    def self.from_rest_json(data_i)
      data = JSON.parse(data_i) 

      return Job.new(
              data, data['input'], data['output']
      )
    end 


    def submit()
      self.jobid = GridVid.submit(@_submit)
      self.jobid 
    end


    def status()
      statuses = GridVid.query(
                    {
                      :key    => @_submit[:key],
                      :secret => @_submit[:secret],
                      :jobids => [self.jobid]
                    }
                  )
    
      statuses.each_pair {|jobid, val|
        case val['status']
        when "PASS"
          return [true , "PASS"]

        when "FAILED"
          return [true , "FAILED"] 
        
        else
          return [false, val["status"]]
        end 
        }
      
      return [false, ""]
    end 
  end
  
end 
