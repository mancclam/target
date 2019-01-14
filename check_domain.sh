#!/bin/bash

t1=`date +%s`
#当前日期时间戳，用于和域名的到期时间做比较

notify()
{ 
  laset_d=`whois $1 | grep "Expiry Date" | awk  '{print $4}' | cut -d "T" -f 1`
  l_d=`date -d "$laset_d" +%s`
  n=`echo "86400*7" | bc`
  e_t1=$[$l_d-$n]
  e_t2=$[$l_d+$n]
  if [ $t1 -ge $e_t1 ] && [ $t1 -lt $l_d]
  then
  fi
  if [ $t1 -ge $l_d ] && [ $t1 -lt $e_t2]
  then
  fi
}

for d in baidu.com qq.com
do
  notify $d &
done
