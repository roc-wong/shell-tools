#!/bin/bash - 
#===============================================================================
#
#          FILE: getopts.sh
# 
#         USAGE: ./getopts.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (王鹏举), float.wong@icloud.com
#  ORGANIZATION: 华宝证券
#       CREATED: 03/28/2018 03:14:34 PM
#      REVISION:  ---
#===============================================================================


export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }' # 第四级提示符变量$PS4, 增强”-x”选项的输出信息

set -o nounset                              # Treat unset variables as an error
set -e



# 选项后面不带:表示无参数, 带:表示有参数

while getopts "ab:" arg

do

        case $arg in

                  a)

                           echo "Optiona";;

                  b)

                           echo "Option b: ${OPTARG}";;

        esac

done

 

shift $((OPTIND-1))  #执行该语句，以便本脚本后面固定参数序号从$1开始.

echo "Process arg: $1"

echo "Process arg: $2"

