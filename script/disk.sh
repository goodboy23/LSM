#!/bin/bash
#磁盘监控组


lsm_init() {
    a=0
}

#查询根目录使用情况
disk_gen_space() {
    local key=`df -Th | grep -w "/" | awk '{print $6}' | awk -F'%' '{print $1}'` #获取的值
	local value_a=100 #报警阀值
	local caveat_a="危险：根目录使用空间超过${value}，当前值：${key}" #警告话语
    local value_b=80
    local caveat_b="严重：根目录使用空间超过${value}，当前值：${key}"
	local value_c=60
	local caveat_c="警告：根目录使用空间超过${value}，当前值：${key}"

    data_log disk_gen_space

    if [ $key -ge $value_a ];then
        error_log disk_gen_space $value_a
	elif [ $key -ge $value_b ];then
		error_log disk_gen_space $value_b
	elif [ $key -ge $value_c ];then
		error_log disk_gen_space $value_c
    fi
}

#查询硬盘i节点
disk_gen_i() {
    local gen_i=`df -i | grep -w "/" | awk '{print $5}' | awk -F'%' '{print $1}'` #获取的值
    local value=80 #报警阀值
    local caveat="根目录i节点超过${value}，当前值：${gen_i}" #警告话语
    
    data_log disk_gen_i $gen_i
    
    if [ $gen_i -ge $value ];then
        error_log disk_gen_i
    fi
}
