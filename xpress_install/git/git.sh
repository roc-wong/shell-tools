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
#  ORGANIZATION: hello roc
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


GIT_VERSION=git-2.9.5
GIT_PATH=/usr/local/git/bin
DOWNLOAD_PATH=https://www.kernel.org/pub/software/scm/git/$GIT_VERSION.tar.gz

#-------------------------------------------------------------------------------
# 安装依赖的软件
#-------------------------------------------------------------------------------
yum install -y wget autoconf make gcc curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker libxslt asciidoc xmlto


#-------------------------------------------------------------------------------
# 下载git
#-------------------------------------------------------------------------------
wget $DOWNLOAD_PATH


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
echo "GIT_PATH=/usr/local/git/bin" >> /etc/profile
echo "export PATH=\"$GIT_PATH:\$PATH\"" >> /etc/profile
source /etc/profile


#-------------------------------------------------------------------------------
# 验证
#-------------------------------------------------------------------------------
cd -
git --version


#-------------------------------------------------------------------------------
# 默认git 别名配置
#-------------------------------------------------------------------------------
git config --global alias.co "checkout"
git config --global alias.ci "commit"
git config --global alias.br "branch"
git config --global alias.st "status"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --abbrev-commit"


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
