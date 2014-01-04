0 2 * * * * root python /var/lib/logstash-index-cleaner/logstash_index_cleaner.py --host {{ hostvars[groups["elasticsearch"][0]]["ansible_hostname"] }} -g {{ logstash_max_data_gb }}
