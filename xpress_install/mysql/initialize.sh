#!/bin/bash - 
#===============================================================================
#
#          FILE: initialize.sh
# 
#         USAGE: ./initialize.sh 
# 
#   DESCRIPTION: mysql 初始化脚本
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (王鹏举), float.wong@icloud.com
#  ORGANIZATION: 华宝证券
#       CREATED: 05/03/2018 02:34:31 PM
#      REVISION:  ---
#===============================================================================


export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }' # 第四级提示符变量$PS4, 增强”-x”选项的输出信息

set -o nounset                              # Treat unset variables as an error
set -e

PASSWORD=$1

echo "password is ${PASSWORD}"
mysql -u root -p${PASSWORD} --connect-expired-password  <<EOF

use mysql;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root');
grant all privileges  on *.* to root@'%' identified by 'password';
flush privileges;

EOF
