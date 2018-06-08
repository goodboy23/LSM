#!/bin/bash
#swap内存使用监控

lsm_init() {
    a=0
}
free_swap(){
#当前时间
shijian=`date +%Y-%m-%d-%T`

#当前系统内存使用大小
swap_total=`free -m |grep Swap|awk '{print $2}'`
#当前系统内存总大小
swap_free=`free -m |grep Swap|awk '{print $NF}'`
#当前系统内存使用比例
swap_load=`echo "scale=2;a=$swap_free/$swap_total;if(length(a)==scale(a)) print 0;print 100" | bc`
swap_warn=20
if [[ $swap_load -lt $swap_warn ]] ;then
        touch /tmp/$shijian-swap.log
        echo "$shijian的swap内存使用超过百分之80，请立即处理。当前剩余swap内存百分比为$swap_load" >>/tmp/$shijian-swap.log
fi
}
