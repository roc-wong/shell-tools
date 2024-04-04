#!/bin/bash - 
#===============================================================================
#
#          FILE: zookeeper.sh
# 
#         USAGE: ./zookeeper.sh 
# 
#   DESCRIPTION: 使用源码安装zookeeper,版本可自行配置
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (王鹏举), float.wong@icloud.com
#  ORGANIZATION: hello roc
#       CREATED: 04/23/2018 08:38:02 PM
#      REVISION:  ---
#===============================================================================

export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
set -x

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


ZOOKEEPER=zookeeper
ZOOKEEPER_VERSION=zookeeper-3.4.11
ZOOKEEPER_PATH=/usr/local/zookeeper
ZOOKEEPER_DOWNLOAD_PATH=http://archive.apache.org/dist/zookeeper/${ZOOKEEPER_VERSION}/${ZOOKEEPER_VERSION}.tar.gz

#-------------------------------------------------------------------------------
# 安装依赖的软件
#-------------------------------------------------------------------------------
yum install -y wget


# 下载zookeeper
#-------------------------------------------------------------------------------
wget ${ZOOKEEPER_DOWNLOAD_PATH}


#-------------------------------------------------------------------------------
# 解压
#-------------------------------------------------------------------------------
tar xzvf ${ZOOKEEPER_VERSION}.tar.gz -C /usr/local/
mv /usr/local/${ZOOKEEPER_VERSION} /usr/local/${ZOOKEEPER}


#-------------------------------------------------------------------------------
# 在主目录下创建data和logs两个目录用于存储数据和日志，设置默认配置
#-------------------------------------------------------------------------------
mkdir -p /usr/local/${ZOOKEEPER}/data
mkdir -p /usr/local/${ZOOKEEPER}/logs

cp /usr/local/${ZOOKEEPER}/conf/zoo_sample.cfg /usr/local/${ZOOKEEPER}/conf/zoo.cfg

cat >> /usr/local/${ZOOKEEPER}/conf/zoo.cfg  << EOF

dataDir=/usr/local/${ZOOKEEPER}/data
dataLogDir=/usr/local/${ZOOKEEPER}/logs

EOF


#-------------------------------------------------------------------------------
# 后台启动zookeeper服务，并增加zookeeper到系统服务.
#-------------------------------------------------------------------------------
cat > /etc/init.d/zookeeper <<EOF
#!/bin/bash -
#
# Zookeeper        Startup script for Zookeeper Server
#
# chkconfig: - 81 13
# description: ZooKeeper is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services.
#
# processname: QuorumPeerMain
# config: /usr/local/zookeeper/conf/zoo.cfg

case \$1 in
	start ) 
		/usr/local/${ZOOKEEPER}/bin/zkServer.sh start
	;;
	stop ) 
		/usr/local/${ZOOKEEPER}/bin/zkServer.sh stop	
	;;
	status )
		/usr/local/${ZOOKEEPER}/bin/zkServer.sh status
	;;
	restart )
		/usr/local/${ZOOKEEPER}/bin/zkServer.sh restart
	;;
	* )
		echo "Usage: zookeeper {start|stop|restart|status}"
	;;
esac

EOF

chmod +x /etc/init.d/zookeeper
chkconfig --add zookeeper


#-------------------------------------------------------------------------------
# 设置系统环境变量
#-------------------------------------------------------------------------------
cat > /etc/profile.d/zookeeper.sh << EOF
#!/bin/bash -
export ZOOKEEPER_HOME=/usr/local/${ZOOKEEPER}
export PATH=\$PATH:\$ZOOKEEPER_HOME/bin
EOF

chmod +x /etc/profile.d/zookeeper.sh
source /etc/profile.d/zookeeper.sh


#-------------------------------------------------------------------------------
# 验证
#-------------------------------------------------------------------------------
service zookeeper start

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

set +x
