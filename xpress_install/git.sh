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

export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
set -x
#set -o nounset                              # Treat unset variables as an error


GIT_VERSION=git-2.9.5

#-------------------------------------------------------------------------------
# 安装依赖的软件
#-------------------------------------------------------------------------------
yum install -y wget autoconf make gcc curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker libxslt asciidoc xmlto


#-------------------------------------------------------------------------------
# 下载git
#-------------------------------------------------------------------------------
wget https://www.kernel.org/pub/software/scm/git/$GIT_VERSION.tar.gz 


#-------------------------------------------------------------------------------
# 编译
#-------------------------------------------------------------------------------
tar xzvf $GIT_VERSION.tar.gz
cd $GIT_VERSION
make prefix=/usr/local/git all
make prefix=/usr/local/git install
source contrib/completion/git-completion.bash


#-------------------------------------------------------------------------------
# 设置系统环境变量
#-------------------------------------------------------------------------------
echo "export GIT_PATH=/usr/local/git/bin" >> /etc/profile
echo "export PATH=$PATH:$GIT_PATH:" >> /etc/profile
source /etc/profile


#-------------------------------------------------------------------------------
# 验证
#-------------------------------------------------------------------------------
echo "============================ git ready ============================"

git --version


#-------------------------------------------------------------------------------
# 默认git 别名配置
#-------------------------------------------------------------------------------
git config --global alias.co "checkout"
git config --global alias.ci "commit"
git config --global alias.br "branch"
git config --global alias.st "status"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --abbrev-commit"


set +x
