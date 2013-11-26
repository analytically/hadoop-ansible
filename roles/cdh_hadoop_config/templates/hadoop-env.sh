# {{ ansible_managed }}

export HADOOP_HEAPSIZE={{ heapsize }}

export HADOOP_OPTS="-server -XX:+UseParallelGC -XX:+AggressiveOpts -XX:+UseNUMA -XX:+UseCondCardMark -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:/var/log/hadoop-hdfs/hadoop-hdfs-gc.log"