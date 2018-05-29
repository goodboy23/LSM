#!/bin/bash
#安全方面

lsm_init() {
    lastb_land_list=() #全局变量，存储表
    lastb_land_wei=0 #表的下标
    lastb_land_time=`date +%D` #当前时间
    
    w_land_ip=`w | awk '/root/{print $3}' | head -1` #当前第一个ip，为本机的
    
    pass_land_hang=`wc -l /etc/passwd | awk '{print $1}'` #获取行数
}

safety_lastb_land() {
    local ip_list=() #临时存储
    local ip_wei=0 #临时位置

    if [[ "$(date +%D)" != "$lastb_land_time" ]];then
        lastb_land_time=`date +%D` #校准日期，天为单位
        lastb_land_list=()
        lastb_land_wei=0
    fi
    
    for i in `lastb | grep "$(date | awk '{print $1,$2,$3}')" |awk '{print $3}' | sort | uniq -c |awk '{if ($1>=10)print $2}'`
    do
         echo ${lastb_land_list[*]} | grep -w "$i" &> /dev/null
         if [[ $? -ne 0 ]];then
             lastb_land_list[$lastb_land_wei]=$i
             let lastb_land_wei++
             ip_list[$ip_wei]=$i
             let ip_wei++
          fi
    done
    
    #这里定义日志
    local value=1 #阀值
    local lastb_ip=`echo ${ip_list[*]}`
    local caveat="今日尝试登陆ip：${lastb_ip}"
    
    data_log safety_lastb_land $lastb_ip
    
    if [[ ${#list_ip[*]} -ge $value ]];then
        error_log safety_lastb_land
    fi
    
 } 
 
  safety_w_land() {
    local value=$w_land_ip #报警阀值
    local abno_ip=`w | awk '/root/{print $3}' | grep -v $value` #获取的值
    local caveat="当前有异地登录，获取的ip：$abno_ip" #警告话语)
 
    echo $value
    echo $abno_ip
    data_log safety_w_land $abno_ip

    if [[ "$abno_ip" != "" ]];then
        error_log safety_w_land
    fi
 }

 safety_pass_land() {
    local value=`wc -l /etc/passwd | awk '{print $1}'`
    local caveat="/etc/passwd有所更改，获取值：${value}行"

    data_log safety_pass_land $pass_land_hang

    if [[ $value -ne $pass_land_hang ]];then
        error_log safety_pass_land
        pass_land_hang=`wc -l /etc/passwd | awk '{print $1}'`
    fi
 }
