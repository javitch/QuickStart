#!/usr/bin/ruby 

require 'rubygems'
require 'gridvid'


job0  = {
  :template => 'apple_ipod_nano_fullscreen',
  :callback => 'http://test.cpusage.com/testcallback'
}

group = GridVid::Group.new(
          {
            :key    => "AKIAI7JRI2PJSRFLHPWA",                                                                                    
            :secret => "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",                                                             
            :bucket => "cpusage01",
            :object => "15_seconds.flv"
          },          
          {
            :key    => "AKIAI7JRI2PJSRFLHPWA",                                                                                    
            :secret => "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",                                                             
            :bucket => "cpusage01",
          }
        )

group.add_job(job0, 'output.mp4')
group.submit() 

while true do
  status = group.status() 
  
  require 'json' 
  puts JSON.generate(status)
  #puts status[0]
  #puts status[1] 
  #puts status[2] 
  #puts status[3] 
  #puts '---------' 

  if status[0]
    break
  end

  sleep(1)
end
