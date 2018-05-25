#!/bin/bash
#主体脚本

lsm_log=/tmp/LSM.log

item=() #存储监控项
item_switch=() #监控项的开关

item_filter() { #监控项的筛选
    local a=0 b=0
    for i in `grep -w "\[.*\]" item.conf | awk -F'[' '{print $2}' | awk -F']' '{print $1}'`
    do
        item[$a]=$i
        let a++
    done
    
    for i in `grep -w "\[.*\]" item.conf | awk -F'=' '{print $2}'`
    do
        item_switch[$b]=$i
        let b++
    done
}

#挨个调用脚本
transfer() {
    local a=0 #值
    for i in `echo ${item[*]}`
    do
        if [[ "${item_switch[$a]}" == "0" ]];then
            $i & #将函数放后台
        fi
        let a++
        sleep 1
    done
}

#main主体

#先搞出监控项的开关
item_filter

#将函数加载进来
for i in `ls script/*`
do
    source $i
done

#不断循环
while [ 1 ]
do
    transfer
done
