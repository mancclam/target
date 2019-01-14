#!/bin/bash
#这是一个傻瓜运维脚本，根据列表输入对应数字即可实现想要功能
#作者：阿铭
#日期：2018-10-04
#版本：v0.1

LANG=en
sar 1 5 > /tmp/cpu.log &
sar -n DEV 1 5 |grep '^Average:' > /tmp/net.log &
echo -n "收集数据"
for i in `seq 1 5`
do
    echo -n "."
    sleep 1
done
echo

t=`date +"%F %T"`
load=`uptime |awk -F 'load averages?: ' '{print $2}'|cut -d '.' -f1`
cpu_idle=`tail -1 /tmp/cpu.log|awk '{print $NF}'`
cpu_use=`echo "scale=2;100-$cpu_idle"|bc`
mem_tot=`free -m |grep '^Mem:'|awk '{print $2}'` 
mem_ava=`free -m |grep '^Mem:'|awk '{print $NF}'`
mysql_p="dR6wB1jzq"
echo -e "\033[32m当前时间：$t \033[0m"
echo "######"
echo -e "\033[31m当前负载：$load \033[0m"
echo "######"
echo -e "\033[33mCPU使用率：$cpu_use% \033[0m"
echo "######"
echo -e "\033[34m内存总数：$mem_tot"MB", 内存剩余：$mem_ava"MB" \033[0m"
echo "######"
echo -e "\033[35m磁盘空间使用情况：\033[0m"
df -h
echo "######"
echo -e "\033[36m磁盘inode使用情况：\033[0m"
df -i
echo "######"
sed '1d' /tmp/net.log |awk '{print "网卡"$2": 入口流量"$5/1000*8"Mbi, 出口流量"$6/1000*8"Mbi"}'
echo "######"

get_acc_log()
{
    tail -100 /data/logs/www.log
}

get_mysql_slow_log()
{
    tail -50 /data/mysql/slow.log
}

get_php_slow_log()
{
    tail -50 /usr/local/php/logs/slow.log
}

restart_php()
{
    /etc/init.d/php-fpm restart
}

restart_nginx()
{
    /etc/init.d/nginx restart
}

get_mysql_process()
{
    mysql -uroot -p$mysql_p -e "show processlist"
}


PS3="请选择你想要做的操作："

select c in 查看访问日志 查看mysql慢查询日志 查看php-fpm的慢执行日志 重启php-fpm服务 重启nginx服务 查看mysql队列 退出脚本
do
    case $c in
查看访问日志)
    get_acc_log
    ;;
查看mysql慢查询日志)
    get_mysql_slow_log
    ;;
查看php-fpm的慢执行日志)
    get_php_slow_log
    ;;
重启php-fpm服务)
    restart_php
    ;;
重启nginx服务)
    restart_nginx
    ;;
查看mysql队列)
    get_mysql_process
    ;;
退出脚本)
    exit 0
    ;;
    esac
done
