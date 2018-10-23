#!/bin/bash - 
#===============================================================================
#
#          FILE: namesrv.sh
# 
#         USAGE: ./namesrv.sh 
# 
#   DESCRIPTION: nameserver 启动脚本
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: roc wong (王飞), float.wong@icloud.com
#  ORGANIZATION: 
#       CREATED: 2018/09/29 13时54分31秒
#      REVISION:  ---
#===============================================================================

# 第四级提示符变量$PS4, 增强”-x”选项的输出信息
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'    

# Treat unset variables as an error
set -o nounset

# Exit the script if an error happens
# set -e

nohup sh mqnamesrv > /dev/null 2>&1 &

