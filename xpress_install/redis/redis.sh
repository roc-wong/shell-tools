#!/bin/bash - 
#===============================================================================
#
#          FILE: redis.sh
# 
#         USAGE: ./redis.sh 
# 
#   DESCRIPTION: 使用源码安装redis,版本可自行配置
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (王鹏举), float.wong@icloud.com
#  ORGANIZATION: 华宝证券
#       CREATED: 04/23/2018 08:38:02 PM
#      REVISION:  ---
#===============================================================================

export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
#set -x

# Only enable exit-on-error after the non-critical colorization stuff,
# which may fail on systems lacking tput or terminfo
set -e

# Treat unset variables as an error
#set -o nounset                             


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


REDIS_VERSION=redis-4.0.9
REDIS_PATH=/usr/local/redis/bin
REDIS_SERVER_SCRIPT_PATH=http://olml6iu96.bkt.clouddn.com/redis

#-------------------------------------------------------------------------------
# 安装依赖的软件
#-------------------------------------------------------------------------------
yum install -y wget autoconf make gcc


# 下载redis
#-------------------------------------------------------------------------------
wget http://download.redis.io/releases/$REDIS_VERSION.tar.gz 


#-------------------------------------------------------------------------------
# 解压，建立软链接
#-------------------------------------------------------------------------------
tar xzvf $REDIS_VERSION.tar.gz -C /usr/local/
cd /usr/local
ln -sv $REDIS_VERSION/ redis


#-------------------------------------------------------------------------------
# 编译
#-------------------------------------------------------------------------------
cd /usr/local/redis
make && cd src && make install && cd -


#-------------------------------------------------------------------------------
# 部署.为了方便管理，将Redis文件中的conf配置文件和常用命令移动到统一文件中
#-------------------------------------------------------------------------------
mkdir -p /usr/local/redis/bin
mkdir -p /usr/local/redis/etc

cp redis.conf redis.conf.bak
mv redis.conf etc/

cd src
mv mkreleasehdr.sh redis-benchmark redis-check-aof redis-cli redis-server /usr/local/redis/bin
cd -


#-------------------------------------------------------------------------------
# 后台启动redis服务，并增加redis到系统服务.
#-------------------------------------------------------------------------------
sed -i 's/daemonize no/daemonize yes/g' etc/redis.conf
wget $REDIS_SERVER_SCRIPT_PATH -O /etc/init.d/redis
chmod +x /etc/init.d/redis
chkconfig --add redis


#-------------------------------------------------------------------------------
# 设置系统环境变量
#-------------------------------------------------------------------------------
echo "#!/bin/bash -" > /etc/profile.d/redis.sh
echo "export REDIS_HOME=/usr/local/redis" >> /etc/profile.d/redis.sh
echo "export PATH=\"$REDIS_PATH:\$PATH\"" >> /etc/profile.d/redis.sh
chmod +x /etc/profile.d/redis.sh
source /etc/profile.d/redis.sh

#-------------------------------------------------------------------------------
# 内存分配策略（若不设置，Redis在重启或停止时，将会报错，并且不能自动在停止服务前同步数据到磁盘。
# 0， 表示内核将检查是否有足够的可用内存供应用进程使用；如果有足够的可用内存，内存申请允许；否则，内存申请失败，并把错误返回给应用进程。
# 1， 表示内核允许分配所有的物理内存，而不管当前的内存状态如何。
# 2， 表示内核允许分配超过所有物理内存和交换空间总和的内存
#-------------------------------------------------------------------------------
echo "${RED}请自行设置内存分配策略：在/etc/sysctl.conf中查找vm.overcommit_memory，将其值修改为1。若无，手动追加."
echo "若不设置，redis会产生告警：Background save may fail under low memory condition. ${NORMAL}"

#-------------------------------------------------------------------------------
# 验证
#-------------------------------------------------------------------------------
service redis start

printf "${GREEN}"
echo "                 .-~~~~~~~~~-._       _.-~~~~~~~~~-.                            "
echo "             __.\'              ~.   .~              \`.__                      "
echo "           .\'//                  \./                  \\\`.                    "
echo "         .\'//                     |                     \\\`.                  "
echo "       .\'// .-~\"\"\"\"\"\"\"~~~~-._     |     _,-~~~~\"\"\"\"\"\"\"~-. \\\`.  "
echo "     .\'//.-\"                 \`-.  |  .-\'                 \"-.\\\`.          "
echo "   .\'//______.============-..   \ | /   ..-============.______\\\`.            "
echo " .\'______________________________\|/______________________________\`.          "
echo "${NORMAL}"
#set +x
