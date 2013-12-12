# {{ ansible_managed }}

export HADOOP_HEAPSIZE={{ heapsize }}

export HADOOP_OPTS="-Xbootclasspath/p:/usr/lib/jvm/floatingdecimal-0.1.jar -server -XX:+UseParallelGC -XX:+AggressiveOpts -XX:+UseNUMA -XX:+UseCondCardMark -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:/var/log/hadoop-hdfs/hadoop-hdfs-gc.log"