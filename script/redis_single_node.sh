#!/bin/bash
# info: monitor redis (single node)
# date: 2018-06-07
# auth: Max

## Configuration
# tos -- receiver
tos=max@client.example.com

# redis nodes(single mode)
redis_nodes=(
	192.168.18.140:6379
	192.168.18.140:6380	
)

# monitor points
monitor_points=(
	blocked_clients
	used_memory
	used_memory_rss
	mem_fragmentation_ratio
	total_commands_processed
	rejected_connections
	expired_keys
	evicted_keys
	keyspace_hits
	keyspace_misses
	maxmemory
)

# redis_cli location
redis_cli=/usr/bin/redis-cli
if [[ ! -f $redis_cli ]];then
	echo "config error: redis-cli not found."
	exit 1
fi

send_alarms(){
	local msg=$1
	echo "Pleae check: $msg" | mail -s "ALARMS: $msg" $tos
}

format_output(){
	local host=$1
	local file=$2
	declare -A myArray
	for item in ${monitor_points[@]}
	do
		local time=$(date +"%F %T")
		local info=$(grep -E "$item:" $file | awk -F ':' '{print $2}' | tr -d '\r')
		myArray[$item]=$info
	done

	#  print result
	for item in ${monitor_points[@]}
	do
		printf "$(date +"%F %T") $host %-30s %30s\n" "$item ${myArray[$item]}"
	done


	used=${myArray['used_memory']}
	maxmem=${myArray['maxmemory']}
	used_percent=$(( ${used}*100 / $maxmem ))
	
	# judge
	if [[ "$used_percent" -gt 80 ]];then
		send_alarms "$host Redis memory has used more than 80%."
	fi
	
	if [[ "${myArray['rejected_connections']}" -gt 10 ]];then
		send_alarms "$host Redis has more than 10 rejected connections."
	fi
	
	if [[ "${myArray['blocked_clients']}" -gt 10 ]];then
		send_alrams "$host Redis has more than 10 blocked clients."
	fi
}


# gather redis information
get_redis_info(){
	local host=$1
	local port=$2
	local passwd=$3
	if [[ -z $passwd ]];then
		$redis_cli -h $host -p $port info > /tmp/redis_info-${host}-${port} 2>&1
		if [[ $? == 0 ]];then
			format_output $host /tmp/redis_info-${host}-${port}
		else
			echo "failed to connect to $host $port"
			exit	
		fi
	else
		$redis_cli -h $host -p $port -a $passwd info > /tmp/redis_info-${host}-${port} 2>&1
		if [[ $? == 0 ]];then
			format_output $host /tmp/redis_info-${host}-${port}
		else
			echo "failed to connect to $host $port"
			exit	
		fi
	fi
}


for node in ${redis_nodes[@]}
do
	host=$(echo $node | awk -F ':' '{print $1}')
	port=$(echo $node | awk -F ':' '{print $2}')
	get_redis_info $host $port
done

