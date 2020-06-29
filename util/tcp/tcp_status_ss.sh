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
ss -tan | awk 'NR>1{socket[$1]++} END{for (i in socket) print i,socket[i]}' >$tmp_file
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
    output=$(awk '/SYN-RECV/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
synsent)
    output=$(awk '/SYN-SENT/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
established)
    output=$(awk '/ESTAB/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
timewait)
    output=$(awk '/TIME-WAIT/{print $2}' $tmp_file)
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
    output=$(awk '/CLOSE-WAIT/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
lastack)
    output=$(awk '/LAST-ACK/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
finwait1)
    output=$(awk '/FIN-WAIT-1/{print $2}' $tmp_file)
    if [ "$output" == "" ]; then
        echo 0
    else
        echo $output
    fi
    ;;
finwait2)
    output=$(awk '/FIN-WAIT-2/{print $2}' $tmp_file)
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
