#!/bin/bash - 
#===============================================================================
#
#          FILE: cleanAndUpdateGit.sh
# 
#         USAGE: ./cleanAndUpdateGit.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: roc wong (王飞), float.wong@icloud.com
#  ORGANIZATION: 
#       CREATED: 2020/02/14 14时33分19秒
#      REVISION:  ---
#===============================================================================

# 第四级提示符变量$PS4, 增强”-x”选项的输出信息
#export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'    

# Treat unset variables as an error
#set -o nounset

# Exit the script if an error happens
# set -e

read_dir(){
    for file in `ls -a $1`
    do
        if [[ $file == '.' || $file == '..' ]]
        then
                continue;
        fi
        if [ -f $1"/"$file/pom.xml ]
        then
            cd $1"/"$file
            mvn clean
            cd -
        else
            read_dir $1"/"$file
            cd ../
        fi
    done
}


read_dir /d/roc.wong/project

