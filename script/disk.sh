#!/bin/bash
#磁盘监控组

#查询跟目录使用情况
disk_gen_space() {
    local gen_space=`df -Th | grep -w "/" | awk '{print $6}' | awk -F'%' '{print $1}'` #获取的值
    local value=80 #报警阀值
    local caveat="根目录使用空间超过${value}，当前值：${gen_space}" #警告话语
    
    data_log disk_gen_space $gen_space
    
    if [ $gen_space -ge $value ];then
        error_log disk_gen_space
    fi
}

#查询硬盘i节点
disk_gen_i() {
    local gen_i=`df -i | grep -w "/" | awk '{print $5}' | awk -F'%' '{print $1}'` #获取的值
    local value=80 #报警阀值
    local caveat="根目录i节点超过${value}，当前值：${gen_i}" #警告话语
    
    data_log disk_gen_i gen_i
    
    if [ $gen_i -ge $value ];then
        error_log disk_gen_i
    fi
}
