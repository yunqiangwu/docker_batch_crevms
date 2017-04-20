#/bin/bash

cat vms_config.csv |cut -d, -f4|xargs docker rm -f
