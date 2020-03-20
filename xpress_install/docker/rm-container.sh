#!/bin/bash - 
#===============================================================================
#
#          FILE: rm-container.sh
# 
#         USAGE: ./rm-container.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (https://roc-wong.github.io), float.wong@icloud.com
#  ORGANIZATION: 中泰证券
#       CREATED: 05/24/2019 12:45:49 PM
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

container_name=$1

if [ 'all' == ${container_name} ]; then
	docker ps -a | awk '{print $1}' | xargs docker rm
else 
	docker ps -a | grep ${container_name} | awk '{print $1}' | xargs docker rm   
fi
