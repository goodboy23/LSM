#!/bin/bash
#内存使用监控
lsm_init() {
    a=0
}
free_Mem(){
#当前时间
shijian=`date +%Y-%m-%d-%T`

#当前系统内存使用大小
free_used=`free -m|grep Mem|awk '{print $3}'`
#当前系统内存总大小
free_total=`free -m |grep Mem|awk '{print $2}'`
#当前系统内存使用比例
free_load=0`echo "scale=2;$free_used/$free_total"|bc`
free_load1=`echo $free_load|awk -F"." '{print $NF}'`
free_warn=30
if [[ $free_load1 -gt $free_warn ]] ;then
        touch /tmp/$shijian-free.log
        echo "$shijian的内存使用超过百分之80，请立即处理。当前内存使用百分比为$free_load" >>/tmp/$shijian-free.log
fi
}
