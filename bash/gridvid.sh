
#
# URL CONSTANTS 
#
cloud_base="https://cloud.cpusage.com/gridvid"
cloud_query="$cloud_base/query"
cloud_discover="$cloud_base/discover" 

# 
# SANITY CHECKS 
#

if [ -z "$GRIDVID_KEY" ];
then
    echo "customer key not set"
    exit 1
fi 

if [ -z "$GRIDVID_SECRET" ];
then
    echo "customer secret not set"
    exit 1
fi 

#
# PRIVATE
#

function impl_submit {
    url=$1
    commit=$2
    
    echo $url >> /tmp/qqq
    echo $commit >> /tmp/qqq
    
    curl -H "content-type:application/json" -X GET \
            -d "$commit" $url 2> /dev/null
}

#
# PUBLIC 
#
function gridvid_submit
{
    if [ -z "$1" ];
    then
        echo "no job passed to submit_job"
        exit 1
    fi 

    echo $(impl_submit "$cloud_base" "$job")
}

#
#   Query a list of jobids 
#   PARAM:  1   =>  ["jobid0","jobid1",...]
#
function gridvid_query
{
    if [ -z $1 ];
    then
        echo "no jobids passed in"
        exit 1
    fi 
    
    jobids="$1"
    
    json="{
    \"key\"     :   \"$GRIDVID_KEY\",
    \"secret\"  :   \"$GRIDVID_SECRET\",
    \"jobids\"  :   $jobids
    }
    "
    
    echo $(impl_submit "$cloud_query" "$json")
} 

#
#   Discover jobs of a status 
#   PARAM:  1   =>  "all/running/finished" [default="all"
#
function gridvid_discover
{
    if [ -z $1 ];
    then
        status="all"
    else 
        status="$1"
    fi 
    
    json="{
    \"key\"     :   \"$GRIDVID_KEY\",
    \"secret\"  :   \"$GRIDVID_SECRET\",
    \"status\"  :   \"$status\"
    }
    "
    
    echo $(impl_submit "$cloud_discover" "$json")
}

