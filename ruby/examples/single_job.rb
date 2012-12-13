#!/usr/bin/ruby 

# Example:
# Single job run. 
 
require 'rubygems'
require 'gridvid' 

job = GridVid::Job.new(
          {
            :video    =>  {
              :codec      => "x264",
              :advanced   =>  {
                "b:v"         => "32k",
                "f"           => "mp4" ,
                "aspect"      => "4:3" ,
                "vf"          => "scale=640:480",
                "subq"        => "7"
              },
              :no_stream  => true,
              :multipass  => false,
            },

            :audio    =>  { 
              :codec      => "mp3"
            },

            :overlay  =>  {
                :input    =>  {
                  :object     => "cpusage_water.png"
                },
                :w_offset => "0",
                :h_offset => "0",
                :scale    => "80x60"
            }
          },

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
            :object => "ruby02/test.mp4"
          }
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

