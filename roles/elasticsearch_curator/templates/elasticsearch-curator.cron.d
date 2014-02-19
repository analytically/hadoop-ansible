0 2 * * * * root python /var/lib/elasticsearch-curator/curator.py --host {{ hostvars[groups["elasticsearch"][0]]["ansible_fqdn"] }} {{ elasticsearch_curator_args }}
