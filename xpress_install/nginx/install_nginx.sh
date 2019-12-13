#!/bin/bash - 
#===============================================================================
#
#          FILE: install_nginx.sh
# 
#         USAGE: ./install_nginx.sh 
# 
#   DESCRIPTION: 使用源码安装nginx
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (王鹏举), float.wong@icloud.com
#  ORGANIZATION: 华宝证券
#       CREATED: 02/08/2018 08:38:02 PM
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


NGINX_VERSION_NUM=1.16.1
NGINX_VERSION=nginx-$NGINX_VERSION_NUM
NGINX_PATH=/usr/local/nginx/sbin
DOWNLOAD_PATH=http://nginx.org/download/$NGINX_VERSION.tar.gz

#-------------------------------------------------------------------------------
# 安装依赖的软件
#-------------------------------------------------------------------------------
yum install -y wget autoconf make gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel unzip patch 


#-------------------------------------------------------------------------------
# 下载nginx、nginx_upstream_check_module
#-------------------------------------------------------------------------------
wget $DOWNLOAD_PATH
wget https://github.com/yaoweibin/nginx_upstream_check_module/archive/master.zip

#-------------------------------------------------------------------------------
# 编译
#-------------------------------------------------------------------------------
unzip master.zip
tar xzvf $NGINX_VERSION.tar.gz

cd $NGINX_VERSION

# 给 Nginx 打补丁
patch -p1 < ../nginx_upstream_check_module-master/check_$NGINX_VERSION_NUM+.patch

./configure --add-module=../nginx_upstream_check_module-master --prefix=/usr/local/nginx --conf-path=/usr/local/nginx/conf/nginx.conf --with-http_gzip_static_module --with-http_ssl_module --with-http_stub_status_module
make && make install


#-------------------------------------------------------------------------------
# 设置系统环境变量
#-------------------------------------------------------------------------------
cat > /etc/profile.d/nginx.sh <<EOF
NGINX_PATH=/usr/local/nginx/sbin
export PATH=\$PATH:\$NGINX_PATH
EOF

source /etc/profile


#-------------------------------------------------------------------------------
# 验证
#-------------------------------------------------------------------------------
nginx


printf "${GREEN}"
echo "                 .-~~~~~~~~~-._       _.-~~~~~~~~~-.                            "
echo "             __.\'              ~.   .~              \`.__                      "
echo "           .\'//                  \./                  \\\`.                    "
echo "         .\'//                     |                     \\\`.                  "
echo "       .\'// .-~\"\"\"\"\"\"\"~~~~-._     |     _,-~~~~\"\"\"\"\"\"\"~-. \\\`.  "
echo "     .\'//.-\"                 \`-.  |  .-\'                 \"-.\\\`.          "
echo "   .\'//______.============-..   \ | /   ..-============.______\\\`.            "
echo " .\'______________________________\|/______________________________\`.          "
printf "${NORMAL}"
#set +x