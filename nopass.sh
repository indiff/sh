#!/bin/bash
#免密登录脚本
#作者:海蓝之心赛
#使用说明
#在和本脚本同级目录下，创建一个名为serverlist.txt的文件，将需要做免密登录的服务器ip地址列表写在serverlist.txt中，每个IP地址占用一行。
#特殊说明,serverlist.txt请在linux服务器中创建，在Windows上创建容易出现编码问题，导致免密登录失败。
current=`pwd`
serverlist=`cat $current/serverlist.txt`
mkdir -p /root/.ssh
ssh-keygen -t rsa -P ''
for ip in $serverlist
do
    echo "#$ip no password."
    ssh root@$ip 'mkdir -p /root/.ssh 2>/dev/null'
    cat /root/.ssh/id_rsa.pub | ssh root@$ip 'cat >> /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys'
done
