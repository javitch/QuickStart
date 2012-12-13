#!/usr/bin/ruby 

# Example: 
# Create an input job with multiple HLS bit-rate outputs.  
#

require 'rubygems'
require 'gridvid'

# some globals:
output_base_name = 'media_output'

#
# Create a new group with the set input file and shared output information
#
group = GridVid::Group.new(
          {
            :key    => ENV["AMZ_KEY"], 
            :secret => ENV["AMZ_SECRET"],
            :bucket => "cpusage01",
            :object => "i_am_legend-tlr1_h480p.mov"
          },          
          {
            :key    => ENV["AMZ_KEY"], 
            :secret => ENV["AMZ_SECRET"],
            :bucket => "cpusage04",
          }
        )

#
# on the first job execute 
#
group.add_job(
    {
      :video    => {
          :codec      => "x264",
          :bitrate    =>  {
            :rate     =>  "256k",
          },
          :advanced   =>  {
            :f        =>  "mp4",
            :subq     =>  "7",
            :vf       =>  "scale=640:480"
          },
          :hls_stream => {}
      },

      :audio    =>  {
        :codec        => "mp3"
      },

      :thumbnails =>  { 
        :format => "png",
        :number => 3,
        :size   => "640x480"
      }
    }, 
    
    "ruby0/#{output_base_name}-256"
)

group.add_job(
    {
      :video    => {
          :codec      => "x264",
          :bitrate    =>  {
            :rate     =>  "128k",
          },
          :advanced   =>  {
            :f        =>  "mp4",
            :subq     =>  "7",
            :vf       =>  "scale=640:480"
          },
          :hls_stream => {}
      },

      :audio    =>  {
        :codec        => "mp3"
      }
    }, 
    
    "ruby0/#{output_base_name}-128"
)

group.add_job(
    {
      :video    => {
          :codec      => "x264",
          :bitrate    =>  {
            :rate     =>  "64k",
          },
          :advanced   =>  {
            :f        =>  "mp4",
            :subq     =>  "7",
            :vf       =>  "scale=640:480"
          },
          :hls_stream => {}
      },

      :audio    =>  {
        :codec        => "mp3"
      }
    }, 
    
    "ruby0/#{output_base_name}-64"
)

group.submit() 

while true do
  status = group.status() 
  
  require 'json' 
  puts JSON.generate(status)

  if status[0]
    break
  end

  sleep(5)
end
