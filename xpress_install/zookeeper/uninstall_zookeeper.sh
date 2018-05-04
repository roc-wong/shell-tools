#!/bin/bash - 
#===============================================================================
#
#          FILE: uninstall_zookeeper.sh
# 
#         USAGE: ./uninstall_zookeeper.sh 
# 
#   DESCRIPTION: 卸载Zookeeper
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (王鹏举), float.wong@icloud.com
#  ORGANIZATION: 华宝证券
#       CREATED: 05/04/2018 04:42:04 PM
#      REVISION:  ---
#===============================================================================


export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }' # 第四级提示符变量$PS4, 增强”-x”选项的输出信息

set -o nounset                              # Treat unset variables as an error
set -e
set -x

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi

if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
	RED="$(tput setaf 1)"
	GREEN="$(tput setaf 2)"
	YELLOW="$(tput setaf 3)"
	BLUE="$(tput setaf 4)"
	BOLD="$(tput bold)"
	NORMAL="$(tput sgr0)"
else
	RED=""
	GREEN=""
	YELLOW=""
	BLUE=""
	BOLD=""
	NORMAL=""
fi


#-------------------------------------------------------------------------------
# 杀死已经启动的zk进程
#-------------------------------------------------------------------------------
echo -e "${RED} Kill zookeeper process if exists ... ${NORMAL}" 
ps -ef | grep 'QuorumPeerMain' | grep -v grep | awk '{print $2}' | xargs --no-run-if-empty kill -9


#-------------------------------------------------------------------------------
# 删除安装文件
#-------------------------------------------------------------------------------
rm -rf /usr/local/zookeeper


#-------------------------------------------------------------------------------
# 删除开机启动项
#-------------------------------------------------------------------------------
rm -rf /etc/init.d/zookeeper
chkconfig --del zookeeper > /dev/null 2>&1


#-------------------------------------------------------------------------------
# 删除环境变量
#-------------------------------------------------------------------------------
rm -rf /etc/profile.d/zookeeper.sh
