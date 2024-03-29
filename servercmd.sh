#!/bin/bash
cd $(cd "$(dirname "$0")" && pwd)
path=`pwd`
usage_str="[start|stop]"
console="127.0.0.1 25001"
version="server/content/config"
datetime=`date "+%Y-%m-%d.%H:%M:%S"`

echo "=============================================="

function start_server()
{
	echo $datetime" 正在启动数据服务..."
	./skynet $version &
	echo $datetime" 服务器启用完成!"
}

function stop_server()
{
	pid=`ps -ef|grep -w $version | grep -v grep | awk '{print $2}'`
	if [ -z "${pid}" ]; then
		return
	fi
	
	(sleep 1;
	 echo start cmd reqexit;
	 sleep 1;
	) | telnet $console
	
	echo $datetime" 开始结束数据服务"
	while true; do
		datetime=`date "+%Y-%m-%d.%H:%M:%S"`
		pid=`ps -ef|grep -w $version | grep -v grep | awk '{print $2}'`
		if [ -z "${pid}" ]; then
			break
		fi
		echo $datetime" 数据服务结束中..."
		sleep 1
	done
	echo $datetime" 结束数据服务完成"
}

if [ $# = 1 ]; then
	case "$1" in
		start)
			stop_server
            start_server
			;;
		stop)
            stop_server
			;;
		*)
			echo "./servercmd.sh $usage_str"
			;;
	esac
	exit
fi

exit
