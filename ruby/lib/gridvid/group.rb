
module GridVid
  require 'gridvid/job' 

  # Public:   Groups GridVid jobid's into a single comprehensible collection 
  # which share redundant submission data and return status'. 
  class Group
    attr_accessor :jobids 

    def initialize(*args)
      @_keys   = {
         :key    =>  GridVid.api_key,
         :secret =>  GridVid.api_sec
      }
      
      @_jobs      = []
      @_places    = {} 
      self.jobids = []

      if args.length == 2
        self.init_with_credentials(args[0], args[1])
      elsif args.length == 1
        self.init_with_jobids(args[0]) 
      end
    end 

    
    # Private:  Initialize with specified credentials (for submitting)
    def init_with_credentials(iput, oput)
      raise 'input must be hash map'  unless iput.kind_of? Hash
      raise 'output must be hash map' unless oput.kind_of? Hash
      
      raise 'api key must be set'    unless GridVid.api_key != nil
      raise 'api secret must be set' unless GridVid.api_sec != nil
      
      @_places = {
        :input  => iput,
        :output => oput
      }
    end

    
    def init_with_jobids(jobids)
      self.jobids = jobids 
    end

    
    # Public:   Adds a job definition to the group
    #
    # +job+ ::  type(Hash) 
    def add_job(job, output_file)
      @_jobs << Job.new(job, @_places[:input], 
                        @_places[:output].merge({:object => output_file})
                    )
    end 
 

    # Public:   Submit the loaded jobs to GridVid and stash the resultant 
    #       jobids  
    def submit()
      @_jobs.each{|job| self.jobids << job.submit()}
    end 
   

    # Public:   Check if all associated jobs have completed.
    # 
    # Returns:  list[
    #           bool(finished), 
    #           list[jobids_passed],
    #           list[jobids_failed],
    #           list[jobids_running]
    #         ]
    def status()
      return [true, [], [], []] if not self.jobids.any?
      
      statuses = GridVid.query(@_keys.merge({:jobids => self.jobids}))
      passed   = []
      running  = [] 
      failed   = [] 
    
      statuses.each_pair {|jobid, val|
        case val['status']
        when "PASS"
          passed  << val['jobid'] 
        when "FAILED" 
          failed  << val['jobid'] 
        else
          running << val['jobid'] 
        end 
        }
      
        return [running.length == 0, passed, failed, running] 
    end 

  end # class Group 
end 
