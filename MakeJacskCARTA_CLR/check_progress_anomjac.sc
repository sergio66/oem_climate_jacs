while true; do printf `date "+%Y/%m/%d:::%H:%M:%S"`; printf ' count so far :  '; ls Anomaly365_16_12p8/*/*.mat | wc -l ; sleep 60; done
