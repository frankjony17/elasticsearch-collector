#!/bin/sh

echo "Executing entrypoint file for Consumer pod"
sysctl -w vm.max_map_count=262144
echo 'vm.max_map_count=262144' >> /etc/sysctl.conf
sysctl -p