#! /bin/bash

# Check to make sure Lidarr is running

QBTNX=$(pgrep mono | wc -l )
if [[ ${QBTNX} -ne 1 ]]
then
	echo "Lidarr process not running"
	exit 1
fi

echo "Lidarr is running"

exit 0

