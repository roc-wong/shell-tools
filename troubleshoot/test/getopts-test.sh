#!/bin/bash - 
#===============================================================================
#
#          FILE: getopts-test.sh
# 
#         USAGE: ./getopts-test.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (王鹏举), float.wong@icloud.com
#  ORGANIZATION: 华宝证券
#       CREATED: 03/28/2018 04:18:22 PM
#      REVISION:  ---
#===============================================================================


export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }' # 第四级提示符变量$PS4, 增强”-x”选项的输出信息

set -o nounset                              # Treat unset variables as an error
set -e

INPUT_PID=

echo "OPTIND starts at $OPTIND"
while getopts ":p:" optname
  do
    case "$optname" in
      "p")
        echo "Option $optname is specified"
        INPUT_PID=${OPTARG}
        ;;
      "?")
        echo "Unknown option $OPTARG"
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        ;;
      *)
        # Should not occur
        echo "Unknown error while processing options"
        ;;
    esac
    echo "OPTIND is now $OPTIND"
done

echo "input dump pids is "${INPUT_PID}

PIDS=(${INPUT_PID})
echo "数组遍历 ${PIDS[*]}"
