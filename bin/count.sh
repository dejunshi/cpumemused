#!/bin/bash
#count.sh
basepath=$(cd `dirname "$0"`;pwd)
path=`echo $basepath | grep -oP "[\/0-9a-zA-Z]+(?=\/bin)"`
today=`/bin/date -d today +"%Y%m%d"`
data_cpu=(`cat $path/log/cpuuserd/$today.log | grep -oP "(?<=CPU_Used:)[0-9\.]+" | xargs -n100000`)
data_mem=(`cat $path/log/cpuuserd/$today.log | grep -oP "(?<=Memory_Used:)[0-9\.]+" | xargs -n100000`)
num1=`cat $path/log/cpuuserd/$today.log | grep "CPU_Used" | wc -l`
num_cpu=`echo ${data_cpu[@]} | sed -r "s/ /+/g;s/.*/scale=2;(&)\/$num1/g" | bc`
num_mem=`echo ${data_mem[@]} | sed -r "s/ /+/g;s/.*/scale=2;(&)\/$num1/g" | bc`
[[ $num_cpu =~ ^\.[0-9]+ ]] && num_cpu="0$num_cpu" || num_cpu="$num_cpu"
[[ $num_mem =~ ^\.[0-9]+ ]] && num_mem="0$num_mem" || num_mem="$num_mem"

echo "DATE:$today  CPU_average:$num_cpu  MEM_average:$num_mem" >> $path/tmp/zl_cpu_average.log

data_gpu=(`cat $path/log/gpuuserd/$today.log | grep -oP "(?<=gpu_used: )[0-9\.]+" | xargs -n100000`)
num2=`cat $path/log/gpuuserd/$today.log | grep "gpu_used" | wc -l`
num_gpu=`echo ${data_gpu[@]} | sed -r "s/ /+/g;s/.*/scale=2;(&)\/$num2/g" | bc`
[[ $num_gpu =~ ^\.[0-9]+ ]] && num_gpu="0$num_gpu" || num_gpu="$num_gpu"

echo "DATE:$today  gpu_average:$num_gpu" >> $path/tmp/zl_gpu_average.log
