#!/bin/bash
#主体脚本



#########数据########
lsm_data_log=/tmp/LSM_data.log

#调用 $1写函数名
data_log() {
    echo $(date +%F/%H/%M/%S) "$1 $key" >> $lsm_data_log
    echo >>  $lsm_data_log
}

#########日志########
lsm_error_log=/tmp/LSM_error.log #日志存储位置

#直接调用，$1填写1=警告，2=严重，3=灾难，$2填写话语
error_log() {
    echo $(date +%F/%H/%M/%S) "$1 $caveat"
    echo >> $lsm_error_log
}

#########开关########
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

#########监控项执行########
transfer() {
    local a=0 #值
    for i in `echo ${item[*]}`
    do
        if [[ "${item_switch[$a]}" == "0" ]];then
            $i & #将函数放后台
        fi
        let a++
    done
}

#########主体########

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
    sleep 60 #60秒检查一次
done