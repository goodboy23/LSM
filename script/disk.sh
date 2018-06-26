#!/bin/bash
#磁盘监控组



#查询根目录使用情况
disk_gen_space() {
    local key=`df -Th | grep -w "/" | awk '{print $6}' | awk -F'%' '{print $1}'` #获取的值
	local value=80 #报警阀值
	local caveat="根目录使用空间超过${value}，当前值：${key}" #告警话语

    data_log disk_gen_space

    if [ $key -ge $value ];then
        error_log disk_gen_space
    fi
}

#查询硬盘i节点
disk_gen_i() {
    local key=`df -i | grep -w "/" | awk '{print $5}' | awk -F'%' '{print $1}'` #获取的值
    local value=80 #报警阀值
    local caveat="根目录i节点超过${value}，当前值：${key}" #警告话语
    
    data_log disk_gen_i
    
    if [ $key -ge $value ];then
        error_log disk_gen_i
    fi
}
