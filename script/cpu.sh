#!/bin/bash
#cpu负载监控
lsm_init() {
    a=0
}

cpu_item(){
load=`uptime`
shijian=`date +%Y-%m-%d-%T`
touch /tmp/cpulog.txt
#统计cpu数目
cpu_num=`grep -c 'model name' /proc/cpuinfo`
#获取当前系统15分钟的平均负载值
load_15=`uptime |awk '{print $NF}'`
#计算当前系统单个核心15分钟的平均负载值
average_load=`echo "scale=2;a=$load_15/$cpu_num;if(length(a)==scale(a)) print 0;print a" | bc`

load_int=`echo $average_load|cut -f 1 -d "."`
load_warn=0.70
if  [[ $load_int -gt 0 ]];then
        echo "$shijian The current load value is $average_load" >>/tmp/cpulog.txt
else
        load_now=`expr $average_load \> $load_warn`
        if (($load_now == 1));then
        echo "$shijian The current load value is $average_load" >>/tmp/cpulog.txt
        fi
fi
}

