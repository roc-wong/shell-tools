#!/bin/bash - 
#===============================================================================
#
#          FILE: install_git_credentials.sh
# 
#         USAGE: ./install_git_credentials.sh 
# 
#   DESCRIPTION: 配置http和https协议的git免密码登陆
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: roc wong (王飞), float.wong@icloud.com
#  ORGANIZATION: 
#       CREATED: 2018/09/06 14时34分31秒
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

echo 'please input remote url, eg : "http://example.com"' 
read localhost
echo "input username"
read username
echo "input password"
read password

if test -e ~/.git-credentials
then
    echo '!! ~/.git-credentials already exist!'
else
    echo ' create ~/.git-credentials '
    touch ~/.git-credentials
fi

echo 'Configure username and password ...'
echo "http://$username:$password@$localhost" >> ~/.git-credentials
git config --global credential.helper store
echo 'Successful!'
