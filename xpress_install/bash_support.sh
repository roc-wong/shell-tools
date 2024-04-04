#!/bin/bash - 
#===============================================================================
#
#          FILE: bash_support.sh
# 
#         USAGE: ./bash_support.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (王鹏举), float.wong@icloud.com
#  ORGANIZATION: hello roc
#       CREATED: 02/08/2018 08:13:11 PM
#      REVISION:  ---
#===============================================================================

#set -x

# Only enable exit-on-error after the non-critical colorization stuff,
# which may fail on systems lacking tput or terminfo
set -e

# Treat unset variables as an error
set -o nounset                             


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


#-------------------------------------------------------------------------------
# 初始化安装所依赖工具
#-------------------------------------------------------------------------------
if command -v wget >/dev/null 2>&1; then
  echo 'command wget found.';
else
  yum install -y wget
fi

if command -v unzip >/dev/null 2>&1; then
  echo 'command unzip found.';
else
  yum install -y unzip
fi

#-------------------------------------------------------------------------------
# 初始化文件目录 .vim
#-------------------------------------------------------------------------------
if [ ! -d "$HOME/.vim/" ]; then
    mkdir -p "$HOME/.vim/"
fi


#-------------------------------------------------------------------------------
# Copy the zip archive bash-support.zip to $HOME/.vim and run
#-------------------------------------------------------------------------------
cd $HOME/.vim/

wget -O bash-support.zip http://www.vim.org/scripts/download_script.php?src_id=24452

unzip bash-support.zip


#-------------------------------------------------------------------------------
# Afterwards, these files should exist:
#-------------------------------------------------------------------------------
if [ ! -d "$HOME/.vim/autoload/mmtemplates/" ]; then
    mkdir -p $HOME/.vim/autoload/mmtemplates/
fi

if [ ! -d "$HOME/.vim/doc/" ]; then
    mkdir -p $HOME/.vim/doc/
fi


#-------------------------------------------------------------------------------
# Loading of plug-in files must be enabled. If not use
#-------------------------------------------------------------------------------
echo "filetype plugin on" >> $HOME/.vimrc
echo "set number" >> $HOME/.vimrc


printf "${GREEN}"
echo "                 .-~~~~~~~~~-._       _.-~~~~~~~~~-.                            "
echo "             __.\'              ~.   .~              \`.__                      "
echo "           .\'//                  \./                  \\\`.                    "
echo "         .\'//                     |                     \\\`.                  "
echo "       .\'// .-~\"\"\"\"\"\"\"~~~~-._     |     _,-~~~~\"\"\"\"\"\"\"~-. \\\`.  "
echo "     .\'//.-\"                 \`-.  |  .-\'                 \"-.\\\`.          "
echo "   .\'//______.============-..   \ | /   ..-============.______\\\`.            "
echo " .\'______________________________\|/______________________________\`.          "
