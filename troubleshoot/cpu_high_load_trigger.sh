#!/bin/bash - 
#===============================================================================
#
#          FILE: cpu_high_load_trigger.sh
# 
#         USAGE: ./cpu_high_load_trigger.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (王鹏举), float.wong@icloud.com
#  ORGANIZATION: 中泰证券
#       CREATED: 03/27/2018 08:34:43 PM
#      REVISION:  ---
#===============================================================================


export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }' # 第四级提示符变量$PS4, 增强”-x”选项的输出信息

#set -o nounset                              # Treat unset variables as an error
#set -e

docker cp /opt/jvm/jstack_dump/jstack.sh backend_zts-intelli-quote-client:/jstack.sh
docker exec -i backend_zts-intelli-quote-client bash -c 'sh /jstack.sh'