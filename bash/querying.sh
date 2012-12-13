#!/bin/bash 

USER_KEY="USER_KEY"
USER_SECRET="USER_SECRET" 

# 
# DISCOVER ALL JOBS RAN 
#
discover_all="{
    \"key\"   :   \"$USER_KEY\",
    \"secret\":   \"$USER_SECRET\",
    \"status\":   \"all\"
}" 

# store job returns into a string buffer
discover_all_ret="`curl -H "content-type:application/json" -X GET \
    -d \"$discover_all\"  https://cloud.cpusage.com/gridvid/discover`"

echo $discover_all_ret 

#
# USE JOB DISCOVERY RETURN TO QUERY JOB STATUS' 
#
query_discovery="{
    \"key\"   :   \"$USER_KEY\",
    \"secret\":   \"$USER_SECRET\",
    \"status\":   \"all\",
    \"jobids\":   $discover_all_ret
}" 

echo $query_discovery 

query_ret="`curl -H "content-type:application/json" -X GET \
    -d \"$query_discovery\"  https://cloud.cpusage.com/gridvid/query`"

echo $query_ret | json_reformat 
