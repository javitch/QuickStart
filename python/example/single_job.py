#!/usr/bin/python 

import os 
import gridvid 

job = gridvid.Job(
        {
            'video' : {
                'codec'     : 'x264',
                'advanced'  : {
                    'b:v'   : '32k',
                    'f'     : 'mp4',
                    'aspect': '4:3',
                    'vf'    : 'scale=640:480',
                    'subq'  : '7'
                },
            },

            'audio' : {
                'codec'     : 'mp3' 
            },

            'callback' : 'http://test.cpusage.com/testcallback'
        },
        {
            'key'   : os.getenv('AMZ_KEY'),
            'secret': os.getenv('AMZ_SECRET'),
            'bucket': 'cpusage01',
            'object': '15_seconds.flv'
        },
        {
            'key'   : os.getenv('AMZ_KEY'),
            'secret': os.getenv('AMZ_SECRET'),
            'bucket': 'cpusage04',
            'object': 'pyth02/test.mp4'
        }
        )

print job.submit() 

import time 
while True:
    time.sleep(5)
    ret = job.status()
    
    print(ret)
    if ret[0]:
        break
