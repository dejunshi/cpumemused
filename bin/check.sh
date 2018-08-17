#check.sh
#!/bin/bash
basepath=$(cd `dirname "$0"`;pwd)
path=`echo $basepath | grep -oP "[\/0-9a-zA-Z]+(?=\/bin)"`
date=`/bin/date -d today +"%Y-%m-%d %T"`
today=`/bin/date -d today +"%Y%m%d"`
echo "DATE:$date" >> $path/log/cpuuserd/$today.log
/bin/cat $path/conf/ip.list_all | while read ip1 user1 password1
do
  /bin/cat $path/etc/cpu_cmd | /usr/bin/ssh $user1@$ip1 "/bin/cat > /tmp/cmd_cpu;/bin/bash /tmp/cmd_cpu $ip1;/bin/rm -rf /tmp/cmd_cpu"
done >> $path/log/cpuuserd/$today.log

echo "DATE:$date" >> $path/log/gpuuserd/$today.log

/bin/cat $path/conf/ip.list_GPU | while read ip2 user2 password2
do
  /bin/cat $path/etc/GPU_cmd | /usr/bin/ssh $user2@$ip2 "/bin/cat > /tmp/cmd_gpu;/bin/bash /tmp/cmd_gpu $ip2;/bin/rm -rf /tmp/cmd_gpu"
done >> $path/log/gpuuserd/$today.log
