#!/bin/bash - 
#===============================================================================
#
#          FILE: start.sh
# 
#         USAGE: ./start.sh 
# 
#   DESCRIPTION: Eureka启动脚本
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: roc wong (王飞), float.wong@icloud.com
#  ORGANIZATION: 
#       CREATED: 2018/11/12 18时05分07秒
#      REVISION:  ---
#===============================================================================

# 第四级提示符变量$PS4, 增强”-x”选项的输出信息
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'    

# Treat unset variables as an error
set -o nounset

# Exit the script if an error happens
# set -e

echo -e "Kill eureka server if exists ..." 
ps -ef | grep 'eureka-server' | grep -v grep | awk '{print $2}' | xargs --no-run-if-empty kill -9

nohup java -jar $1 &
