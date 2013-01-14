#!/usr/bin/ruby 

# Example:
# Single job run. 
 
require 'rubygems'
require 'gridvid' 

job = GridVid::Job.from_rest_json(
          '{
            "input"   : {
              "key"   : "AKIAI7JRI2PJSRFLHPWA", 
              "secret": "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", 
              "bucket": "cpusage01",
              "object": "i_am_legend-tlr1_h480p.mov"
            },

            "output"  : {
              "key"   : "AKIAI7JRI2PJSRFLHPWA", 
              "secret": "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", 
              "bucket": "cpusage04",
              "object": "ruby02/test.mp4"
            },
          
            "video"   :  {
              "codec"     : "x264",
              "advanced"  :  {
                "b:v"         : "32k",
                "f"           : "mp4" ,
                "aspect"      : "4:3" ,
                "vf"          : "scale=640:480",
                "subq"        : "7"
              },
              
              "no_stream" : true,
              "multipass" : false
            },

            "audio"   :  { 
              "codec"     : "mp3"
            },

            "overlay" :  {
                "input"   :  {
                  "object"    : "cpusage_water.png"
                },
                "w_offset": "0",
                "h_offset": "0",
                "scale"   : "80x60"
            }
          }'
)



job.submit() 

while true do
  stat = job.status() 

  puts stat[1]
  if stat[0]

    break
  end 
  
  sleep(5)
end 

