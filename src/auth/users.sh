#!/bin/bash

#set_users(){
#    hash=$(/elasticsearch/plugins/search-guard-6/tools/hash.sh -p $ELASTIC_PWD)
#    sed -ie '/^elastic:/{s|hash:[^\r\n#]/hash:.*/hash: ''/;}' /elasticsearch/config/searchguard/sg_internal_users.yml
#
#    hash=$(/elasticsearch/plugins/search-guard-6/tools/hash.sh -p $KIBANA_PWD)
#    sed -ie '/^kibana:/{n;s/hash:.*/hash: '$hash'/;}' /elasticsearch/config/searchguard/sg_internal_users.yml
#
#    hash=$(/elasticsearch/plugins/search-guard-6/tools/hash.sh -p $LOGSTASH_PWD)
#    sed -ie '/^logstash:/{n;s/hash:.*/hash: '$hash'/;}' /elasticsearch/config/searchguard/sg_internal_users.yml
#
#    hash=$(/elasticsearch/plugins/search-guard-6/tools/hash.sh -p $BEATS_PWD)
#    sed -ie '/^beats:/{n;s/hash:.*/hash: '$hash'/;}' /elasticsearch/config/searchguard/sg_internal_users.yml
#
#    cat /elasticsearch/config/searchguard/sg_internal_users.yml
#}
#
#set_users

