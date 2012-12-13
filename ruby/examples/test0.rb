#!/usr/bin/env ruby 

require 'gridvid'

GridVid.api_key = '4fc1246b319680d3410002bf'
GridVid.api_sec = 'prodserverlicense'

ggroup = GridVid::Group.new(
            {
                :key    => "AKIAI7JRI2PJSRFLHPWA",                                                                                    
                :secret => "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",                                                             
                :bucket => "cpusage01",
                :object => "15_seconds.flv"
            },
            {
                :key    => "AKIAI7JRI2PJSRFLHPWA",                                                                                    
                :secret => "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",                                                             
                :bucket => "cpusage04" 
            }
        )

ggroup.add_job(
        {
        :template   =>  "apple_ipod_nano_fullscreen",
        :callback   =>  "http://test.cpusage.com/testcallback"
        }
        )

#jobids = ggroup.jobids

#ggroup.submit()
