# {{ ansible_managed }}

export HADOOP_HEAPSIZE={{ heapsize }}

export HADOOP_OPTS="-Xbootclasspath/p:/usr/lib/jvm/floatingdecimal-0.1.jar -XX:+UseConcMarkSweepGC -XX:+AggressiveOpts -XX:MaxPermSize=300M -XX:+CMSClassUnloadingEnabled -XX:SurvivorRatio=8 -XX:+ExplicitGCInvokesConcurrent -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:/var/log/hadoop-hdfs/hadoop-hdfs-gc.log"