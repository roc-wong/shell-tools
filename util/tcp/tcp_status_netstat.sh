#!/bin/bash - 
#===============================================================================
#
#          FILE: tcp_status.sh
# 
#         USAGE: ./tcp_status.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (https://roc-wong.github.io), float.wong@icloud.com
#  ORGANIZATION: 中泰证券
#       CREATED: 05/07/2020 10:04:57 AM
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

#!/bin/bash
#this script is used to get tcp and udp connetion status
#tcp status
metric=$1
tmp_file=/tmp/tcp_status.txt
/bin/netstat -an | awk '/^tcp/{++S[$NF]}END{for(a in S) print a,S[a]}' >$tmp_file
case $metric in
closed)
    output=$(awk '/CLOSED/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
listen)
    output=$(awk '/LISTEN/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
synrecv)
    output=$(awk '/SYN_RECV/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
synsent)
    output=$(awk '/SYN_SENT/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
established)
    output=$(awk '/ESTABLISHED/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
timewait)
    output=$(awk '/TIME_WAIT/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
closing)
    output=$(awk '/CLOSING/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
closewait)
    output=$(awk '/CLOSE_WAIT/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
lastack)
    output=$(awk '/LAST_ACK/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
finwait1)
    output=$(awk '/FIN_WAIT1/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
finwait2)
    output=$(awk '/FIN_WAIT2/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
*)
    echo -e "\e[033mUsage: sh $0 [closed|closing|closewait|synrecv|synsent|finwait1|finwait2|listen|established|lastack|timewait]\e[0m"
    ;;
esac
