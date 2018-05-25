#!/bin/bash
#主体脚本

#挨个调用脚本
transfer() {
    local a
    for i in `cat script/*`
    do
        grep -w "^${i}" a.txt | awk -F'=' '{print $2}'
        if [[ "$a" == "0" ]];then
            bash script/$i &
        fi
        sleep 1
    done
}

#不断循环
while [ 1 ]
do
    transfer
done
