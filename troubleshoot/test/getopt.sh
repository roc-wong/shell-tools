#!/bin/bash - 
#===============================================================================
#
#          FILE: getopt.sh
# 
#         USAGE: ./getopt.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (王鹏举), float.wong@icloud.com
#  ORGANIZATION: 华宝证券
#       CREATED: 03/28/2018 03:17:23 PM
#      REVISION:  ---
#===============================================================================


export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }' # 第四级提示符变量$PS4, 增强”-x”选项的输出信息

set -o nounset                              # Treat unset variables as an error
set -e


# -o或--options, 后面接短选项;  -l或--long, 后面接长选项;

# 多个长选项之间用,分隔, 类似于短选项, 选项后面不带:表示无参数, 带1个:表示有参数, 而带2个::表示参数可有可无.

ARGS=`getopt -o xy:z:: -l xlong,ylong:,zlong:: -n 'getopt.sh' -- "$@"`

if [ $? != 0 ]; then

        exit 1

fi

 

eval set -- "${ARGS}"    # 将规范化的参数分配至位置参数($1,$2,...)

 

while true

do

        case $1 in

                  -x|--xlong)

                           echo "Option x"; shift;;

                  -y|--ylong)

                           echo "Option y: $2"; shift 2;;

                  -z|--zlong)

                           case $2 in

                                    "")

                                              echo "Option z: no argument"; shift;;

                                    *)

                                              echo "Option z: $2"; shift 2;;

                           esac;;

                  --)

                           shift; break;;

        esac

done

 

# 处理剩余参数

for arg in $@

do

        echo "Process $arg"

done

