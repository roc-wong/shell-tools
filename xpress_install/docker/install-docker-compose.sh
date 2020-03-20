#!/bin/bash - 
#===============================================================================
#
#          FILE: install-docker-compose.sh
# 
#         USAGE: ./install-docker-compose.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (https://roc-wong.github.io), float.wong@icloud.com
#  ORGANIZATION: 中泰证券
#       CREATED: 05/23/2019 04:27:32 PM
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose

