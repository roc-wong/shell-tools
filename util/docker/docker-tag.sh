#!/bin/bash -
#===============================================================================
#
#          FILE: start.sh
#
#         USAGE: ./start.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Roc Wong (https://roc-wong.github.io), float.wong@icloud.com
#  ORGANIZATION: 中泰证券
#       CREATED: 06/12/2019 09:06:43 PM
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

IMAGE_NAME=$2
VERSION=$3

function tag_aly() {
    docker tag ${IMAGE_NAME}:${VERSION} registry.cn-hangzhou.aliyuncs.com/zts-framework/${IMAGE_NAME}:${VERSION}
    docker push registry.cn-hangzhou.aliyuncs.com/zts-framework/${IMAGE_NAME}:${VERSION}
}

function tag_hwy() {
    docker tag ${IMAGE_NAME}:${VERSION} swr.cn-east-2.myhuaweicloud.com/ztwjyf/${IMAGE_NAME}:${VERSION}
    docker push swr.cn-east-2.myhuaweicloud.com/ztwjyf/${IMAGE_NAME}:${VERSION}
}


case "$1" in
    aly)
        tag_aly
    ;;
    hwy)
        tag_hwy
    ;;
    *)
        echo $"Usage: $0 {aly|hwy|szy}"
        exit 1
esac
