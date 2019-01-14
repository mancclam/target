#!/bin/bash

time=`date -d "-1 hour" +%Y-%m-%d-%H:%M:%S`
log="/var/log/httpd/access_log"

block_ip()
{
  ip=`cat $log | awk '{print $1}' | sort | uniq -c | sort -rn | awk '$1>300 {print $2}'`

  echo "$ip" >> /shell/tmp/banip.txt
  n=`wc -l /shell/tmp/banip.txt | awk '{print $1}'`
  if [ $n -ne 0 ]
  then
    for iphosts in $ip
    do
      iptables -I INPUT -s $iphosts -j REJECT
    done
  fi
}

unblock_ip()
{
  iptables -nvL INPUT  |sed "1,2d" | awk ' {print $8}' > /shell/tmp/good_ip.txt            ##需要另外在iptables表获取已禁止的IP
  n=` wc -l /shell/tmp/good_ip.txt | awk '{print $1}'` 
  if [ $n -ne 0 ]
  then
    for ipdeny in `cat /shell/tmp/good_ip.txt`
    do 
      iptables -D INPUT -s $ipdeny -j REJECT
    done
    echo "解封的IP地址有：$ip" >> /shell/tmp/allowip.txt
  fi
}
t=`date +%M`

if [ $t == "00" ] || [ $t == "30" ]
then
  unblock_ip
  block_ip
else
  block_ip
  #unblock_ip
fi
  

