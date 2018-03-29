#!/bin/bash - 
#===============================================================================
#
#          FILE: dump.sh
# 
#         USAGE: ./dump.sh 
# 
#   DESCRIPTION: 每次线上环境一出问题，大家就慌了，通常最直接的办法回滚重启，以减少故障时间，这样现场就被破坏了，要想事后查问题就麻烦了，有些问题必须在线上的大压力下才会发生，线下测试环境很难重现，不太可能让开发或 Appops 在重启前，先手工将出错现场所有数据备份一下，所以最好在 kill 脚本之前调用 dump，进行自动备份，这样就不会有人为疏忽。
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (王鹏举), float.wong@icloud.com
#  ORGANIZATION: 华宝证券
#       CREATED: 03/27/2018 08:34:43 PM
#      REVISION:  ---
#===============================================================================


export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }' # 第四级提示符变量$PS4, 增强”-x”选项的输出信息

#set -o nounset                              # Treat unset variables as an error
#set -e

JAVA_HOME=/usr/java/jdk1.7.0_55 
OUTPUT_HOME=~/output  
DEPLOY_HOME=`dirname $0`  
HOST_NAME=`hostname`  


usage()
{
    echo -e "Usage: dump.sh [OPTION]。\n" 
    echo -e "使用\"dump.sh -p jvm进程号\"指定jvm进程进行备份，不使用-p参数时，默认查找tomcat用户对应的java进程。\n"    
    echo -e "dump信息涵盖操作系统和JVM，主要用到的命令包括：jstack、jinfo、jstat、jmap、lsof、sar、uptime、free、vmstat、mpstat、iostat、netstat。\n"
    echo -e "备份文件路径：~/output/"
    exit 1
}


#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  read_pid
#   DESCRIPTION:  接收用户输入的进程号
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------
read_pid ()
{	
    read -p "请输入执行dump的JVM进程号(PID): " pid
    
    if [ -z "$pid" ] || [[ ! "$pid" =~ ^-?[0-9]+$ ]]; then  
        echo "-_- 都特么这时候了，你就不能输入正确的进程ID嘛……"  
        exit 1;  
    fi
    echo ${pid}  
}	# ----------  end of function read_pid  ----------


input_pid=
while getopts ":p:h" optname
  do
    case "$optname" in
      "p")
        input_pid=${OPTARG}
        ;;
      "h")
        usage
        ;;
      "?")
        echo "Unknown option $OPTARG"
        usage
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        usage
        ;;
      *)
        # Should not occur
        echo "Unknown error while processing options"
        usage
        ;;
    esac
done

if [ ! ${input_pid} ]; then 
    echo -e "\n"
    echo -e "当前运行的java进程有：\n"
    ps -ef --width 175 | grep java
    echo -e "\n"
    
    input_pid=`read_pid`
fi

DUMP_PIDS=(${input_pid})

DUMP_ROOT=$OUTPUT_HOME/dump  
if [ ! -d $DUMP_ROOT ]; then  
    mkdir -p $DUMP_ROOT  
fi  

DUMP_DATE=`date +%Y%m%d%H%M%S`  
DUMP_DIR=$DUMP_ROOT/dump-$DUMP_DATE  
if [ ! -d $DUMP_DIR ]; then  
    mkdir -p $DUMP_DIR  
fi  

echo -e "\n Dumping the server $HOST_NAME ...\c"  

for PID in $DUMP_PIDS ; do  
    $JAVA_HOME/bin/jstack -F $PID > $DUMP_DIR/jstack-$PID.dump 2>&1  
    echo -e ".\c"  
    $JAVA_HOME/bin/jinfo $PID > $DUMP_DIR/jinfo-$PID.dump 2>&1  
    echo -e ".\c"  
    $JAVA_HOME/bin/jstat -gcutil $PID > $DUMP_DIR/jstat-gcutil-$PID.dump 2>&1  
    echo -e ".\c"  
    $JAVA_HOME/bin/jstat -gccapacity $PID > $DUMP_DIR/jstat-gccapacity-$PID.dump 2>&1  
    echo -e ".\c"  
    $JAVA_HOME/bin/jmap $PID > $DUMP_DIR/jmap-$PID.dump 2>&1  
    echo -e ".\c"  
    $JAVA_HOME/bin/jmap -heap $PID > $DUMP_DIR/jmap-heap-$PID.dump 2>&1  
    echo -e ".\c"  
    $JAVA_HOME/bin/jmap -histo $PID > $DUMP_DIR/jmap-histo-$PID.dump 2>&1  
    echo -e ".\c"  
    if [ -r /usr/sbin/lsof ]; then  
        /usr/sbin/lsof -n -p $PID > $DUMP_DIR/lsof-$PID.dump  
        echo -e ".\c"  
    fi  
done  
if [ -r /usr/bin/sar ]; then  
    /usr/bin/sar > $DUMP_DIR/sar.dump  
    echo -e ".\c"  
fi  
if [ -r /usr/bin/uptime ]; then  
    /usr/bin/uptime > $DUMP_DIR/uptime.dump  
    echo -e ".\c"  
fi  
if [ -r /usr/bin/free ]; then  
    /usr/bin/free -t > $DUMP_DIR/free.dump  
    echo -e ".\c"  
fi  
if [ -r /usr/bin/vmstat ]; then  
    /usr/bin/vmstat > $DUMP_DIR/vmstat.dump  
    echo -e ".\c"  
fi  
if [ -r /usr/bin/mpstat ]; then  
    /usr/bin/mpstat > $DUMP_DIR/mpstat.dump  
    echo -e ".\c"  
fi  
if [ -r /usr/bin/iostat ]; then  
    /usr/bin/iostat > $DUMP_DIR/iostat.dump  
    echo -e ".\c"  
fi  
if [ -r /bin/netstat ]; then  
    /bin/netstat -n > $DUMP_DIR/netstat.dump  
    echo -e ".\c"  
fi  
echo "OK!"

