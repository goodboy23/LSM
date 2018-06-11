#！/bin/bash
#cpu监控组

#load average占用
cpu_load_space () {
local cpu_num=`grep 'model name' /proc/cpuinfo |wc -l` #统计cpu核数
local load_average=`uptime | awk -F ":" '{print $NF}'|awk -F ","'{print $3}'` #load average取值。
declare cpu_value=`awk 'BEGIN {print $cpu_num*0.8}'` #报警阀值计算结果
local value=80 #报警阀值
local caveat="load average已达${cpu_value}" # 警告话语

#日志
date +%F/%H/%M/%S >> $lsm_log
echo load average值已经达到${cpu_value} >> $lsm_log

#判断
if [ $load_average -ge $cpu_value ];then
   echo $caveat
   echo $caveat >> $lsm_log
fi
echo >> $lsm_log #空格

}
