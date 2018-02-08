#!/bin/bash - 
#===============================================================================
#
#          FILE: git.sh
# 
#         USAGE: ./git.sh 
# 
#   DESCRIPTION: 使用源码安装git
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

set -o nounset                              # Treat unset variables as an error

GIT_VERSION=git-2.9.5

#-------------------------------------------------------------------------------
# 安装依赖的软件
#-------------------------------------------------------------------------------
yum install -y wget autoconf make gcc curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker


#-------------------------------------------------------------------------------
# 下载git
#-------------------------------------------------------------------------------
wget https://www.kernel.org/pub/software/scm/git/$GIT_VERSION.tar.gz 


#-------------------------------------------------------------------------------
# 编译
#-------------------------------------------------------------------------------
tar xzvf $GIT_VERSION.tar.gz

cd $GIT_VERSION
make prefix=/usr/local all
make prefix=/usr/local install
source contrib/completion/git-completion.bash


#-------------------------------------------------------------------------------
# 设置系统环境变量
#-------------------------------------------------------------------------------
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/profile
source /etc/profile

echo "============================ git ready ============================"

#-------------------------------------------------------------------------------
# 验证
#-------------------------------------------------------------------------------
git --version
