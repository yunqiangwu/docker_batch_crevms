#!/bin/bash
# show IP


LC_ALL=C ifconfig  | grep 'inet '| grep -v '127.0.0.1'|tr -s '\t' ' '|grep -Po "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"|head -n 1