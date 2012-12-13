#!/bin/bash 

source ./gridvid.sh

jobids=$(gridvid_discover)
statuses=$(gridvid_query $jobids)

echo $statuses | json_reformat
