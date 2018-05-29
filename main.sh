#!/bin/bash
#主体脚本



#########记录########
lsm_data_log=/tmp/LSM_data.log

#调用 $1写函数名，$2为值，监控项只有一个值
data_log() {
    echo $(date +%F/%H/%M/%S) "$1 $2" >> $lsm_data_log
    echo >>  $lsm_data_log
}

#########记录########
lsm_error_log=/tmp/LSM_error.log #日志存储位置

#直接调用，$1写上函数名
error_log() {
    echo $(date +%F/%H/%M/%S) "$1 报警：${caveat}" #显示
    echo $(date +%F/%H/%M/%S) "$1 报警：${caveat}" >> $lsm_error_log
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
        sleep 60 #60秒检查一次
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
done
