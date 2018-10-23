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

urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
    
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    
    LC_COLLATE=$old_lc_collate
}

urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

echo 'please input remote url, eg : "www.example.com", without "http/https" prefix' 
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

## 使用邮箱登录时进行urlencode
encode_username=`urlencode $username`

url="http://$encode_username:$password@$localhost"

echo $url >> ~/.git-credentials
git config --global credential.helper store
echo 'Successful!'
