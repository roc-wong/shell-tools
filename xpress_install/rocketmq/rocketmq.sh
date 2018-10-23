#!/bin/bash - 
#===============================================================================
#
#          FILE: rocketmq.sh
# 
#         USAGE: ./rocketmq.sh 
# 
#   DESCRIPTION: RocketMQ 环境变量设置
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: roc wong (王飞), float.wong@icloud.com
#  ORGANIZATION: 
#       CREATED: 2018/09/29 10时11分44秒
#      REVISION:  ---
#===============================================================================

# 第四级提示符变量$PS4, 增强”-x”选项的输出信息
#export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }' 

#set -o nounset                              # Treat unset variables as an error

export ROCKETMQ_HOME=/usr/local/rocketmq
export PATH=$PATH:$ROCKETMQ_HOME/bin
