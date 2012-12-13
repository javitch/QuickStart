#!/usr/bin/env ruby

# Internal tests for raw HTTP execution.
# KEY and SECRET must be exported for this test to work 

require 'gridvid'

test_discover = {
  :key    => GridVid.api_key,
  :secret => GridVid.api_sec,
  :status => "all"
}

jobs = GridVid.discover(test_discover)

# 
# TEST QUERY FROM DISCOVERY
#

test_query    = {
  :key    => GridVid.api_key,
  :secret => GridVid.api_sec,
  :jobids => jobs
}

stats = GridVid.query(test_query)

stats.each_pair {|jobid, value|
  puts "%s\t%s" % [jobid, value['status']]
}
