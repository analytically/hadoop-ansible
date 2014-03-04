0 2 * * * * root curator --host {{ hostvars[groups["elasticsearch"][0]]["ansible_fqdn"] }} {{ elasticsearch_curator_args }}
