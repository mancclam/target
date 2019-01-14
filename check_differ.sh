#!/bin/bash

#思路：
#1、实现免密登录
#2、将A机需要检查的目录做md5处理





Bip=134.175.185.204
dir=/tmp/

[ -f /tmp/md5.list ] && rm -rf /tmp/md5.list


a_operation()
{
cd $dir
find . \( -path "./shell*" -o -path "./jumpserver*" \) -prune -o -type f > /tmp/file.list
for i in `cat /tmp/file.list`:
do
    md5sum $i >> /tmp/md5.list
done
chmod 775 /tmp/md5.list
rsync -ave "ssh -p 60000"  /tmp/md5.list  134.175.185.204:/tmp/
}

[ -f /tmp/check_md5.sh ] && rm -rf /tmp/check_md5.sh

b_operation()
{
   ##用Here Document编写check_md5.sh脚本内容
cat >/tmp/check_md5.sh << EOF
#!/bin/bash 
cd \$dir
n=\`wc -l /tmp/md5.list | awk '{print \$1}'\`
for i in \`seq 1 \$n\`
do 
  file_name=\`sed -n "\$i"p /tmp/md5.list | awk '{print \$2}'\`
  md5=\`sed -n "\$i"p /tmp/md5.list | awk '{print \$1}'\`
  if [ -f \$file_name ]
  then
    md5_b=\`md5sum \$file_name | awk '{print \$1}'\`
  if [ \$md5 != \$md5_b ]
  then
    echo "\$file_name change."
  fi
  else
    echo "\$file_name lose."
  fi
done > /data/change.log
EOF
chmod 777 /tmp/check_md5.sh
rsync -ave "ssh -p 60000" /tmp/check_md5.sh $Bip:/tmp/
ssh -p 60000 $Bip "sh /tmp/check_md5.sh"
}
a_operation
b_operation
