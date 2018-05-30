#!/bin/bash
#内存监控组

#查询系统内存使用情况
memory_ram_space () {
   local memory_userd=`free -m |grep -w "Mem"|awk '{print $3/$2*100}'` #内存使用量取值
   local memory_swap=`free -m |grep -w "Swap"|awk '{print $3}'` #swap取值
   local value=1 #报警阀值swap>1
   local caveat="系统内存使用量已达${memory_userd}%,占用swap空间${memory_swap}" #警告话语
   
   #日志
   date +%F/%H/%M/%S >> $lsm_log
   echo 已用swap空间:${memory_swap} >> $lsm_log

   if [ $memory_swap -ge $value ];then
       echo $caceat
       echo $caceat >> $lsm_log
   fi
   echo >> $lsm_log #空格
}
   
