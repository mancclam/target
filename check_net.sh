#!/bin/bash

if ! rpm -q sysstat &>/dev/null 
then
  yum install -y sysstat
fi

#将10秒的网卡流量写进日志
sar -n DEV 1 10 | grep "eth0" > /shell/tmp/net_eth0.log

net_in=`cat /shell/tmp/net_eth0.log | grep "^Average" | awk '{print $5}'`
net_out=`cat /shell/tmp/net_eth0.log | grep "^Average" | awk '{print $6}'`
echo "net_in：$net_in" >> /shell/tmp/net.log
echo "net_out： $net_out" >> /shell/tmp/net.log


net_in_last=`tail -2 /shell/tmp/net.log | grep "net_in" | awk -F "：" '{print $2}'`
net_out_last=`tail -2 /shell/tmp/net.log | grep "net_out" | awk -F "：" '{print $2}'`

net_in_diff=`$[$net_in-$net_in_last]`
net_out_diff=`$[$net_out-$net_out_last]`

if [ $net_in_diff -gt $net_in_last] || [ $net_out_diff -gt $net_out_last]
then
  echo "`date` 网卡入口增幅异常" >> /shell/tmp/net.log
fi





#if [ $net_in == "0.00" ] && [ $net_out == "0.00" ]
#then 
#  echo "`date` eth0网卡异常，重启网卡。">> /shell/tmp/net.log
#  ifdown eth0 && ifup eth0
#fi

#if [ ! -f /shell/tmp/net.log ] 
#then
#  echo "net_in $net_in" >> /shell/tmp/net.log
#  echo "net_out $net_out" >> /shell/tmp/net.log
#fi
