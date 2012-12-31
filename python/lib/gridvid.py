"""
:module gridvid: 

"""
import urllib2 
import json 
from   os import getenv 

__API_KEY    = getenv('GRIDVID_KEY')    if getenv('GRIDVID_KEY')    else None 
__API_SECRET = getenv('GRIDVID_SECRET') if getenv('GRIDVID_SECRET') else None 
__API_URL    = 'https://cloud.cpusage.com/gridvid'


class SubmitException(RuntimeError):
    """
    :class SubmitException:
    """
    pass 

class NetException(RuntimeError):
    """
    :class NetException:
    """
    pass 


def __impl_net(url, payload, method = None):
    """
    :param url: 
    :type  url:     str() 

    :param payload: 
    :type  payload: dict() 

    :param method:  Force a specific request type if not None. 
    :type  method:  str() / None
    """
    req = urllib2.Request(url, json.dumps(payload),
            {'Content-Type' : 'application/json' }
            )

    if method:
        assert method in ('GET', 'POST', 'PUT') 
        ret.get_method = lambda: method 

    return json.loads(
            urllib2.urlopen(req).read() 
            )


def __impl_submit(job_submit):
    """
    :param job_submit:
    :type  job_submit:  dict()

    :raise SubmitException: If the submission has failed for a content issue 
                            or any other unknown issue.
    :raise NetException:    If it has failed to connect to the REST api.
    """
    try:
        ret = __impl_net(__API_URL, job_submit) 
    except Exception as err:
        raise NetException('Failed to submit to GridVid')

    if ret['status'] != 'SUCCESS':
        if 'info' in ret:
            raise SubmitException(ret['info'])
        elif not 'jobid' in ret:
            raise SubmitException('no jobid returned') 
        else:
            raise SubmitException('unknown error') 
    
    return ret['jobid']


def __impl_query(job_query):
    """
    :param job_query:   
    :type  job_query:   dict() 
    """
    try: 
        ret = __impl_submit('%s/query', __API_URL, job_query)
    except Exception as err:
        raise NetException('Failed to submit to GridVid') 


def __impl_discover(disc_query):
    """
    :param disc_query:   
    :type  disc_query:  dict() 
    """
    try: 
        ret = __impl_submit('%s/query', __API_URL, job_query)
    except Exception as err:
        raise NetException('Failed to submit to GridVid') 
    

class Job(object):
    """
    :class Job: 
    """
    def __init__(self, jobd, iput, oput):
        """
        :param jobd:    Job data to submit 
        :type  jobd:    dict() 

        :param iput:    
        :type  iput:    dict() 
        
        :param oput:    
        :type  oput:    dict() 
        """
        if not isinstance(jobd, dict):
            raise TypeError('Job description must be of type dict()')

        if not isinstance(jobd, dict):
            raise TypeError('output place must be of type dict()')

        if not isinstance(jobd, dict): 
            raise TypeError('input place must be of type dict()')
       
        self.__job_data = {
                'key'       : __API_KEY,
                'secret'    : __API_SECRET, 
                'input'     : iput, 
                'output'    : oput
                }
        self.__job_data.update(jobd) 

    
    def jobid(self):
        """
        :return:    The jobid associated with this job  
        :type  :    str()

        :raise RuntimeError:    If the job has not been set.
        """
        if not self.__jobid:
            raise RuntimeError('Job has not yet been submitted') 
        else:
            return self.__jobid 


    def submit(self):
        """
        """
        self.__jobid = __impl_submit(self.__job_data)['jobid'] 
        return self.__jobid 


    def status(self):
        """
        In the return tuple, the first argument will be set to True if the job 
        has completed (whether it failed or succeeded).  If it has not completed 
        the second parameter will always be false.  Once completed, the second 
        parameter will be True if job passed, False if failed.

        :return:    (Job has completed, Job Succeeded)
        :type  :    tuple(bool(), bool()) 
        """
        if not self.__jobid:
            raise RuntimeError('Job has not yet been submitted')

        query = {
            'key'    : __API_KEY,
            'secret' : __API_SECRET, 
            'jobids' : [self.__jobid] 
            }

        ret = __impl_discover(query)  
        
        if   not self.__jobid in ret:
            raise RuntimeError('JobId not in return query') 
        elif not 'status' in ret: 
            raise RuntimeError('JobStatus not in return query') 
        else:
            if ret['status'] in ('PASS', 'FAILED'):
                return (True , ret['status'] == 'PASS')
            else 
                return (False, False) 


class Group(object):
    """
    :class Group:
    """
    def __init__(self, iput, oput):
        """
        """
        self.__iput = iput 
        self.__oput = oput 

        self.__job_obj_l = list()   #<-- job object (pre-submit) 
        self.__job_str_l = list()   #<-- job ids    (post-submit) 
   

    def add_job(self, job, output_file):
        """
        """
        if not isinstance(job, dict):
            raise TypeError('Submitted job must be of type dict()')
        if not isinstance(output_file, basestring):
            raise TypeError('Output file must be of type str()')
        
        job.update({
            'input'     : self.__iput,
            'output'    : self.__oput.update({
                                    'object' : output_file
                                    })
            })
        self.__job_obj_l.append(job) 


    def submit(self):
        """
        """
        assert len(self.__job_obj_l) == 0
        self.__job_str_l = [x.submit() for x in self.__job_obj_l]
        return self.__job_str_l


    def status(self):
        """
        :return:    tuple(completed?, succesful jobs, failed jobs, running jobs)
        :type  :    tuple(list(), list(), list()) 
        """
        query = {
            'key'    : __API_KEY,
            'secret' : __API_SECRET 
            'jobids' : self.__job_str_l
            }

        ret = __impl_discover(query)  
        
        # check that all of the jobids are in the response 
        if not all(jobid in ret for jobid in self.__job_str_l):
            raise RuntimeError('JobID missing from query status') 
        
        # check all of the statuses 
        rets = [list(), list(), list()]

        for jobid, jobstat in ret.iteritems():
            if not 'status' in jobstat:
                rets[1].append(jobid)    
            else:
                if   jobstat['status'] in ('PASS'):
                    rets[0].append(jobid)  
                elif jobstat['status'] in ('FAIL', 'FAILED'):
                    rets[1].append(jobid) 
                else: #<-- presumably still running 
                    rets[2].append(jobid) 

       return tuple([len(rets[2] == 0)] + rets)           

