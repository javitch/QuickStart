#!/usr/bin/python 

import os 
import gridvid 

group = gridvid.Group(
            {
                'key'   : os.getenv('AMZ_KEY'   ),
                'secret': os.getenv('AMZ_SECRET'),
                'bucket': 'cpusage01',
                'object': '15_seconds.flv'
            },
            {
                'key'   : os.getenv('AMZ_KEY'   ),
                'secret': os.getenv('AMZ_SECRET'),
                'bucket': 'cpusage04'
            }
            )

group.add_job(
        {
            'video' : {
                'codec'         : 'x264',
                'multipass'     : False,
                'hls_stream'    : {}, 
                'quality'       : 3
            },

            'audio' : {
                'codec'         : 'mp3',
                'quality'       : 3
            }, 
            'callback' : 'http://test.cpusage.com/testcallback'
        }, 'pyth0/output-q3' 
        )

group.add_job(
        {
            'video' : {
                'codec'         : 'x264',
                'multipass'     : False,
                'hls_stream'    : {}, 
                'quality'       : 1 
            },

            'audio' : {
                'codec'         : 'mp3',
                'quality'       : 1
            }, 
            'callback' : 'http://test.cpusage.com/testcallback'
        }, 'pyth0/output-q1' 
        )


print group.submit() 

import time 

while True:
    time.sleep(4) 

    stat = group.status() 
    
    print(stat) 

    if stat[0]:
        break 



            
