#!/usr/bin/ruby 

require 'rubygems'
require 'gridvid' 

oput_fname = 'output' 
oput_bname = 'rubytest' 

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
# add the primary output video with stills and clip 
#

group.add_job(
  {
    :video      => {
      :codec      => "x264",
      :multipass  => true, 
      :quality    => 3,
      :advanced   => {
        :s      => "1280x720",
        :vf     => "scale=1280x720"
      }
    },

    :audio      =>  {
      :codec      => "aac",
      :quality    => 4
    },

    :thumbnails =>  {
      :output_name=> "#{oput_bname}/stills/#{oput_fname}-stills-",
      :format     => "jpg",
      :time_codes => [
        0, 14, 15, 16, 30, 35, 50, 70, 80
      ]
    },

    :clips      =>  [
      {
        :name   => "#{oput_bname}/clip/#{oput_fname}-clip.mp4",
        :start  => 9,
        :length => 30, 
        :size   => "940x534"
      }
    ],
    :callback => "http://test.cpusage.com/testcallback"
  }, "#{oput_bname}/#{oput_fname}-720.mp4" 
)

group.add_job( 
  {
    :video    => {
      :codec      => "x264",
      :multipass  => true, 
      :quality    => 3,
      :advanced   => {
        :s  => "950x534",
        :vf => "scale=950x534"
      }
    },

    :audio    => {
      :codec      => "aac",
      :quality    => 4 
    },

    :thumbnails   => {
      :output_name=> "#{oput_bname}/thumbnails/#{oput_fname}-thumbnails-",
      :format     => "jpg",
      :size       => "200x112",
      :time_codes => [
        0, 14, 15, 16, 30, 35, 50, 70, 80
      ]
    },
    :callback => "http://test.cpusage.com/testcallback"
  }, "#{oput_bname}/#{oput_fname}-534.mp4" 
)

group.add_job( 
  {
    :video    => {
      :codec      => "x264",
      :multipass  => true, 
      :quality    => 3,
      :advanced   => {
        :s  => "640x360",
        :vf => "scale=640x360"
      }
    },

    :audio    => {
      :codec      => "aac",
      :quality    => 4 
    },

    :callback => "http://test.cpusage.com/testcallback"
  }, "#{oput_bname}/#{oput_fname}-360.mp4"
)

#
# Web-M values 
#
group.add_job( 
  {
    :video    => {
      :codec    => "vpx",
      :multipass=> true, 
      :quality  => 4,
      :advanced => {
        :s  => "950x534",
        :vf => "scale=950x534"
      }
    },
    
    :audio    => {
      :codec    => "vorbis", 
      :quality  => 4 
    }, 

    :clips      => [
      {
        :name   => "#{oput_bname}/clip/#{oput_fname}-clip.webm",
        :start  => 9,
        :length => 30, 
        :size   => "940x534" 
      }
    ],

    :callback => "http://test.cpusage.com/testcallback"
  }, "#{oput_bname}/#{oput_fname}-534.webm" 
)

group.submit() 

require 'json' 

while true do 
  status = group.status 

  puts JSON.generate(status) 

  if status[0]
    break
  end 

  sleep(5)
end 
