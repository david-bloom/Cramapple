#!/bin/bash
# usage: ./stamp.sh "<step>" "<event: start|end>" "<my token counter reading>" ["note"]
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ)|$(date +%s)|$1|$2|$3|$4" >> METRICS_RAW.log
