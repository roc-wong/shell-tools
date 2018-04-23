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

# 下载redis
#-------------------------------------------------------------------------------
wget http://download.redis.io/releases/$REDIS_VERSION.tar.gz 


#-------------------------------------------------------------------------------
# 编译
#-------------------------------------------------------------------------------
tar xzvf $REDIS_VERSION.tar.gz
cd $REDIS_VERSION
make prefix=/usr/local/redis all
make prefix=/usr/local/redis install


#-------------------------------------------------------------------------------
# 设置系统环境变量
#-------------------------------------------------------------------------------
echo "REDIS_PATH=/usr/local/redis/bin" >> /etc/profile
echo "export PATH=\"$REDIS_PATH:\$PATH\"" >> /etc/profile
source /etc/profile


#-------------------------------------------------------------------------------
# 验证
#-------------------------------------------------------------------------------


printf "${GREEN}"
echo "                 .-~~~~~~~~~-._       _.-~~~~~~~~~-.                            "
echo "             __.\'              ~.   .~              \`.__                      "
echo "           .\'//                  \./                  \\\`.                    "
echo "         .\'//                     |                     \\\`.                  "
echo "       .\'// .-~\"\"\"\"\"\"\"~~~~-._     |     _,-~~~~\"\"\"\"\"\"\"~-. \\\`.  "
echo "     .\'//.-\"                 \`-.  |  .-\'                 \"-.\\\`.          "
echo "   .\'//______.============-..   \ | /   ..-============.______\\\`.            "
echo " .\'______________________________\|/______________________________\`.          "

#set +x
