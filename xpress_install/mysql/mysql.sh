#!/bin/bash - 
#===============================================================================
#
#          FILE: mysql.sh
# 
#         USAGE: ./mysql.sh 
# 
#   DESCRIPTION: 使用源码安装mysql,版本可自行配置
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
set -o nounset                             


export debug=false
#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  DEBUG
#   DESCRIPTION:  调试函数 
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------
DEBUG ()
{
	if [ "$debug" = "true" ]; then
        	$@
    	fi
}	# ----------  end of function DEBUG  ----------


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


MYSQL_DOWNLOAD_PATH=https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz
MYSQL=mysql
MYSQL_PATH=/usr/local/mysql

#-------------------------------------------------------------------------------
# 安装依赖的软件
#-------------------------------------------------------------------------------
yum install -y wget install perl perl-devel autoconf libaio
yum remove libnuma.so.1
yum -y install numactl.x86_64


# 下载mysql
#-------------------------------------------------------------------------------
DEBUG wget -O ${MYSQL}.tar.gz $MYSQL_DOWNLOAD_PATH

#-------------------------------------------------------------------------------
# 解压
#-------------------------------------------------------------------------------
if [ ! -d "./${MYSQL}" ];then
mkdir ${MYSQL}
fi

tar -xzvf ${MYSQL}.tar.gz -C ./${MYSQL} --strip-components 1
mv ${MYSQL} /usr/local/


#-------------------------------------------------------------------------------
# 创建用户组mysql
#-------------------------------------------------------------------------------
user=mysql 
group=mysql 
#create group if not exists  
egrep "^$group" /etc/group >& /dev/null  
if [ $? -ne 0 ]  
then  
    groupadd $group  
fi  
  
#create user if not exists  
egrep "^$user" /etc/passwd >& /dev/null  
if [ $? -ne 0 ]  
then 	 
    useradd -r -g ${group} -s /sbin/nologin ${user}
fi 


#-------------------------------------------------------------------------------
# 开启mysql服务，以及设置相关权限
#-------------------------------------------------------------------------------
mkdir /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

sudo touch /var/log/mysqld.log
sudo chown mysql:mysql /var/log/mysqld.log
sudo chcon system_u:object_r:mysqld_log_t:s0 /var/log/mysqld.log


#-------------------------------------------------------------------------------
# 初始化数据库
#-------------------------------------------------------------------------------
cd /usr/local/mysql
mkdir data
chown -R mysql:mysql ./

bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data


#-------------------------------------------------------------------------------
# 配置/etc/my.cnf
#-------------------------------------------------------------------------------
echo "[mysqld]" > /etc/my.cnf
echo "character_set_server=utf8" >> /etc/my.cnf
echo "init_connect='SET NAMES utf8'" >> /etc/my.cnf
echo "basedir=/usr/local/mysql" >> /etc/my.cnf
echo "datadir=/usr/local/mysql/data" >> /etc/my.cnf
echo "socket=/tmp/mysql.sock" >> /etc/my.cnf
echo "  " >> /etc/my.cnf
echo "##不区分大小写" >> /etc/my.cnf
echo "lower_case_table_names = 1" >> /etc/my.cnf
echo "log-error=/var/log/mysqld.log" >> /etc/my.cnf
echo "pid-file=/var/run/mysqld/mysqld.pid" >> /etc/my.cnf


#-------------------------------------------------------------------------------
# 添加开机启动.
#-------------------------------------------------------------------------------
cp /usr/local/mysql/support-files/mysql.server  /etc/init.d/mysql

sed -i '46c basedir=/usr/local/mysql' /etc/init.d/mysql
sed -i '47c datadir=/usr/local/mysql/data' /etc/init.d/mysql

chmod +x /etc/init.d/mysql

chkconfig --add mysql


#-------------------------------------------------------------------------------
# 设置系统环境变量
#-------------------------------------------------------------------------------
echo "#!/bin/bash -" > /etc/profile.d/mysql.sh
echo "export MYSQL_HOME=/usr/local/mysql" >> /etc/profile.d/mysql.sh
echo "export PATH=$MYSQL_HOME/bin:\$PATH" >> /etc/profile.d/mysql.sh
chmod +x /etc/profile.d/mysql.sh
source /etc/profile.d/mysql.sh


#-------------------------------------------------------------------------------
# 验证
#-------------------------------------------------------------------------------
service mysql start

echo -e "${RED} ---> If success, it will output password in '[Note] A temporary password is generated for root@localhost: '. <--- \n"
echo -e "       ---> Or you can find password in '/var/log/mysqld.log'. <--- ${NORMAL}"

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
