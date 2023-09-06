#!/bin/bash

declare -A node_key
node_key=(
    ["1"]="KEY_1"
    ["2"]="KEY_2"
    ["3"]="KEY_3"
    # Add more nodes and keys as needed
)

base_url="https://monitor.incognito.org/pubkeystat/stat"
container_name="inc_mainnet_"

for node_name in "${!node_key[@]}"; do
    key="${node_key[$node_name]}"
    response=$(curl -s "$base_url" -H 'accept: application/json' -H 'content-type: application/json' --data "{\"mpk\":\"$key\"}" | jq -r '.[].SyncState')

    if [ "$response" == "BEACON STALL" ]; then
        echo -n "Restarting Container "
        sudo docker restart "${container_name}${node_name}"
    fi
done

sleep 2
exit 0
