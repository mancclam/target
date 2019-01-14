#!/bin/sh
touch /data/user_passwd 

groupadd users
for i in `seq 1 5`
do
useradd -g users user_$i
passwd=`mkpasswd -l 12 -s 0`
echo -e "$passwd" | passwd --stdin user_$i
echo "user$i ；$passwd" >>/data/user_passwd
done

