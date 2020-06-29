#!/bin/bash

BASEDIR=`dirname $0`
BASEDIR=`cd $BASEDIR;pwd`

result_dir=$BASEDIR/result
telnet_info=$1

if [ -d ${result_dir} ];then
    mkdir -p ${result_dir}
fi

for line in `cat $BASEDIR/$telnet_info`
do
	ip=`echo $line | awk 'BEGIN{FS="|"} {print $1}'`
	port=`echo $line | awk 'BEGIN{FS="|"} {print $2}'`
	echo "(sleep 1;) | telnet $ip $port"
	(sleep 1;) | telnet $ip $port > $result_dir/telnet_result.txt
	successIp=`cat $result_dir/telnet_result.txt | grep -B 1 \] | grep [0-9] | awk '{print $3}' | cut -d '.' -f 1,2,3,4`
	if [ -n "$successIp" ]; then
		echo "$successIp|$port" >> $result_dir/telnet_alive.txt
	fi
done

cat $BASEDIR/$telnet_info $result_dir/telnet_alive.txt | sort | uniq -u > $result_dir/telnet_die.txt


