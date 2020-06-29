#!/bin/bash -
#===============================================================================
#
#          FILE: jstack.sh
#
#         USAGE: ./jstack.sh
#
#   DESCRIPTION: 每次线上环境一出问题，大家就慌了，通常最直接的办法回滚重启，以减少故障时间，这样现场就被破坏了，要想事后查问题就麻烦了，有些问题必须在线上的大压力下才会发生，线下测试环境很难重现，不太可能让开发或 Appops 在重启前，先手工将出错现场所有数据备份一下，所以最好在 kill 脚本之前调用 dump，进行自动备份，这样就不会有人为疏忽。
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

DUMP_DATE=$(date +%Y%m%d%H%M%S)
DUMP_PATH=/data/logCenter/jvm/jstack_dump/$DUMP_DATE

if [ ! -d $DUMP_PATH ]; then
    mkdir -p $DUMP_PATH
fi

pid=$(pidof java)
i=0
while [ $i -lt 15 ]; do
    /bin/sleep 1
    i=$(expr $i + 1)
    ps H -eo user,pid,ppid,tid,time,%cpu,cmd --sort=-%cpu >"$DUMP_PATH/thread-no-$i".dump
    jstack $pid >>"$DUMP_PATH/thread-no-$i".dump
done
