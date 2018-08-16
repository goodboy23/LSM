#!/bin/bash
#cpu负载监控



cpu_five_load () {
    local cpu_num=`grep 'model name' /proc/cpuinfo |wc -l` #统计cpu核数
    local load_average=`uptime | awk -F ":" '{print $NF}'|awk -F "," '{print $3}'` #load average取值。
    local key=`bc <<< ${load_average}*100/${cpu_num} | awk -F'.' '{print $1}'`
    local value=80 #报警阀值
    local caveat="cpu使用超过${value}，当前值${key}" # 警告话语

    data_log cpu_five_load

    if [ $key -ge $value];then
        error_log cpu_five_load
    fi

}
