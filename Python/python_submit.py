#!/usr/bin/python 
import os 
import glob
from StringIO import StringIO  
from pycurl import Curl  
from json import loads, dumps 


BASE_URL = 'https://cloud.cpusage.com/gridvid'

def gridvid_submit(json_dict):
    """ Submission from a dict()->JSON
    Returns a JSON->dict() of the response.
    """
    url  = BASE_URL 
    output_buffer = StringIO()
    curl = Curl() 
    curl.setopt(curl.URL, url)
    curl.setopt(curl.WRITEFUNCTION, output_buffer.write)
    curl.setopt(curl.POST, 1)
    curl.setopt(curl.HTTPHEADER, 
            ['Content-type: application/json', 'Content-Length: %s' % len(json_dict)]
            )

    curl.setopt(curl.SSL_VERIFYPEER, 0)
    curl.setopt(curl.SSL_VERIFYHOST, 0)
    curl.setopt(curl.POSTFIELDS, json_dict)
    curl.setopt(curl.VERBOSE, 0)
    
    buf = None 
    try:
        curl.perform()
        buf = output_buffer.getvalue()
        print buf
        return loads(buf)
    except Exception as err:
        print('Failed to perform curl: %s' % err)
           
        if buf != None:
            print(buf) 
        return None


def execute_jobs_bank(base_path):
    #Get files of type .json
    tests =glob.glob('%(base_path)s/*.json'%vars())
    
    for test in tests:
        try:
            abspath = os.path.abspath(test)
            data    = loads(open(abspath).read())
        
        except Exception as err:
            print('WARNING: Failed to process %s (%s)' % (test, err))
            continue 
        
        #Submit to cpusage
        response = gridvid_submit(dumps(data))
        '''
        #Check for status
        if response == None:
            raise RuntimeError('response from submission null, should not be')
        if response['status'] == 'SUCCESS': print response['jobid'],' Submit Status: SUCCESS'
        else: print test, response['status']
        '''
    return


def main(base_path):
    execute_jobs_bank(base_path)
    return 0 


if __name__ == '__main__':
    import sys 
    
    if len(sys.argv) != 2:
        print('usage: ./simple_submit.py directory/with/tests') 
        sys.exit(1)
    else:
        sys.exit(main(sys.argv[1])) 

