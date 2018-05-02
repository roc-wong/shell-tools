#!/bin/bash - 
#===============================================================================
#
#          FILE: uninstall_mysql.sh
# 
#         USAGE: ./uninstall_mysql.sh 
# 
#   DESCRIPTION: 卸载mysql脚本
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (王鹏举), float.wong@icloud.com
#  ORGANIZATION: 华宝证券
#       CREATED: 05/02/2018 04:38:07 PM
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
# 删除mysql安装目录
#-------------------------------------------------------------------------------
rm -rf /usr/local/mysql


#-------------------------------------------------------------------------------
# 删除mysql用户组、用户
#-------------------------------------------------------------------------------
mysql_user=mysql
mysql_group=mysql
egrep "^${mysql_group}" /etc/group >& /dev/null 
if [ $? -ne 0 ]
then
   groupdel ${mysql_group} 
fi

egrep "^${mysql_user}" /etc/passwd >& /dev/null
if [ $? -ne 0 ]
then 
   userdel ${mysql_user}
fi


#-------------------------------------------------------------------------------
# 删除mysql服务，以及设置相关权限
#-------------------------------------------------------------------------------
rm -rf /var/run/mysqld
rm -rf /var/log/mysqld.log


#-------------------------------------------------------------------------------
# 删除配置/etc/my.cnf
#-------------------------------------------------------------------------------
rm -rf /etc/my.cnf


#-------------------------------------------------------------------------------
# 删除开机启动项
#-------------------------------------------------------------------------------
rm -rf /etc/init.d/mysql
chkconfig --del mysql > /dev/null 2>&1


#-------------------------------------------------------------------------------
# 删除环境变量
#-------------------------------------------------------------------------------
rm -rf /etc/profile.d/mysql.sh

set +x
