#!/bin/bash

PACKAGES=(
    'nano'
    'python3'
    'python3-pip'
    'vim'
    'wget'
    'tmux'
    'vsftpd'
)

PY_PACKAGES=(
    'google-api-python-client'
    'google-cloud-storage'
	# 'google-cloud-bigquery'
)

PING_HOST=8.8.8.8
until ( ping -q -w1 -c1 $PING_HOST > /dev/null ) ; do
    echo "Waiting for internet"
    sleep .5
done

echo "sudo yum install -y ${PACKAGES[*]}"
until ( sudo yum install -y ${PACKAGES[*]} > /dev/null ) ; do
    echo "yum failed to install packages. Trying again in 5 seconds"
    sleep 5
done

echo   "sudo pip3 install --upgrade ${PY_PACKAGES[*]}"
until ( sudo pip3 install --upgrade ${PY_PACKAGES[*]} ) ; do
    echo "pip3 failed to install python packages. Trying again in 5 seconds"
    sleep 5
done


# Set SE Linux to permissive
setenforce 0