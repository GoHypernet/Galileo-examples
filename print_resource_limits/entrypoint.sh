#!/usr/bin/env bash

NPROC=$(nproc)
echo "Number of Processors: $NPROC"
FREE=$(free -h | tail -n2 | head -n1 | awk '{print $2}')
echo "Total Memory: $FREE"
