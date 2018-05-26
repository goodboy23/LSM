#!/bin/bash
#磁盘监控组

#查询硬盘i节点
disk_gen_space() {
    local dis_i=`df -Th | grep -w "/" | awk '{print $6}' | awk -F'%' '{print $1}'` #获取的值
    local value=80 #报警阀值
    local caveat="根目录使用空间超过${value}，当前获取值${dis_i}" #警告话语
    
    #日志
    date +%F/%H/%M/%S  >> $lsm_log
    echo 根目录使用空间获取值：${dis_i} >> $lsm_log
    
    if [ $dis_i -ge $value ];then
        echo $caveat
        echo $caveat >> $lsm_log
    fi
    echo >> $lsm_log #空格
}

#查询硬盘i节点
disk_gen_i() {
    local dis_i=`df -i | grep -w "/" | awk '{print $5}' | awk -F'%' '{print $1}'` #获取的值
    local value=80 #报警阀值
    local caveat="根目录节点超过${value}，当前获取值${dis_i}" #警告话语
    
    #日志
    date +%F/%H/%M/%S  >> $lsm_log
    echo 硬盘i节点获取值：${dis_i} >> $lsm_log
    
    if [ $dis_i -ge $value ];then
        echo $caveat
        echo $caveat >> $lsm_log
    fi
    echo >> $lsm_log #空格
}
