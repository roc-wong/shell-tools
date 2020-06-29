#!/bin/bash - 
#===============================================================================
#
#          FILE: random_request.sh
# 
#         USAGE: ./random_request.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (https://roc-wong.github.io), float.wong@icloud.com
#  ORGANIZATION: 中泰证券
#       CREATED: 06/25/2019 11:04:11 AM
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error


function random_str() {
    MATRIX="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    LENGTH="6"
    while [ "${n:=1}" -le "$LENGTH" ]; do
        PASS="$PASS${MATRIX:$(($RANDOM % ${#MATRIX})):1}"
        let n+=1
    done
    echo "$PASS"
}

function random_num() {
    min=$1
    max=$(($2 - $min + 1))
    num=$(($RANDOM + 1000000000)) #添加一个10位的数再求余
    echo $(($num % $max + $min))
}


for ((i = 1; i <= 1; i++)); do
    #random_url=$(random_str)
    random_url=test
    sleep_time=$(random_num 1000 2000)
    url="https://api-dev.ztsrd.com/api/gosub/random/${random_url}?sleep=${sleep_time}&parameter=${random_url}"
    curl -k ${url}
    
    url_4xx="https://api-dev.ztsrd.com/api/gosub/random1/${random_url}?sleep=1&parameter=${random_url}"
    curl -k ${url_4xx}

    url_5xx="https://api-dev.ztsrd.com/api/gosub/random/error/${random_url}?sleep=2&parameter=${random_url}"
    curl -k ${url_5xx}
done
