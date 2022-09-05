#!/bin/bash

cat topics_orig.txt | grep -P "^\d+\." | sed -E "s/’/'/g" | sed -E 's/^[0-9]+//g' | awk '{print NR$0}' > topics.txt
