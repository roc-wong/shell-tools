#!/bin/bash - 
#===============================================================================
#
#          FILE: rm-images.sh
# 
#         USAGE: ./rm-images.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (https://roc-wong.github.io), float.wong@icloud.com
#  ORGANIZATION: 中泰证券
#       CREATED: 05/24/2019 12:42:30 PM
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

image_name=$1

docker images -a | grep ${image_name} | awk '{print $3}' | xargs --no-run-if-empty docker rmi
