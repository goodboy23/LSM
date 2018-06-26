#!/bin/bash



free_Mem(){
    #当前系统内存使用大小
    local free_used=`free -m|grep Mem|awk '{print $3}'`
    #当前系统内存总大小
    local free_total=`free -m |grep Mem|awk '{print $2}'`
    #当前系统内存使用比例
    local free_load=`echo "scale=2;$free_used/$free_total"|bc`
    local key=`echo $free_load|awk -F"." '{print $NF}'`
    local value=80
    local caveat="内存使用超过${value}，当前值：${key}" #告警话语

    data_log free_Mem

    
    if [ $key -ge $value];then
        error_log free_Mem
    fi
}

free_Swap(){
    #当前swap内存使用大小
    local swap_total=`free -m |grep Swap|awk '{print $2}'`
    #当前swap内存总大小
    local swap_free=`free -m |grep Swap|awk '{print $NF}'`
    #当前swap内存使用比例，可能为0
    if [[ $swap_free -eq 0 ]];then
        local key=0
    else
        local key=`echo "scale=2;a=$swap_free/$swap_total;if(length(a)==scale(a)) print 0;print 100" | bc`
    fi
    local value=80
    local caveat="Swap使用超过${value}，当前值：${key}" #告警话语
    
    data_log free_Swap
    
    if [ $key -ge $value];then
        error_log free_Swap
    fi
}