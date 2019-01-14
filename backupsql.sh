#!/bin/bash

user="root"
passwd="Aa123456"
backupdir="/data/backup"
remote_dir="134.175.185.204:/mysqlbak"
d1=`date +%F`
d2=`date +%d`

#定义日志
exec &> /tmp/shell/mysql_bak.log

echo "mysql backup begin at `date`"

##对需要备份的数据库进行遍历
for db in jumpserver mysql test data3307
do
  mysqldump -u$user -p$passwd  $db >$backupdir/$db-$d1.sql
done

##压缩sql文件
find $backupdir/ -type f -name "*.sql" -mtime +1 | xargs gzip

##查找一周以前的文件，并删除
find $backupdir/ -mtime +7 | xargs rm -rf

#把备份的数据同步到远程备份中心
for db in jumpserver mysql test data3307
do
  rsync -ave "ssh -p 60000" $backupdir/$db-$d1.sql $remote_dir/
done

echo "mysql backup end at `date`"
