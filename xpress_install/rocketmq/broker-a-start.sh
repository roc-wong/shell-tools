#!/bin/bash - 
#===============================================================================
#
#          FILE: broker-a-start.sh
# 
#         USAGE: ./broker-a-start.sh 
# 
#   DESCRIPTION: broker 启动脚本，修改conf文件以实现不同的集群部署方式 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: roc wong (王飞), float.wong@icloud.com
#  ORGANIZATION: 
#       CREATED: 2018/09/29 13时41分02秒
#      REVISION:  ---
#===============================================================================

# 第四级提示符变量$PS4, 增强”-x”选项的输出信息
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'    

# Treat unset variables as an error
# set -o nounset

# Exit the script if an error happens
# set -e

echo -e "Kill rocketmq broker progress if exists ..." 
ps -ef | grep 'org.apache.rocketmq.broker.BrokerStartup' | grep -v grep | awk '{print $2}' | xargs --no-run-if-empty kill -9

nohup sh mqbroker -c $ROCKETMQ_HOME/conf/2m-2s-sync/broker-a.properties > /dev/null 2>&1 &
