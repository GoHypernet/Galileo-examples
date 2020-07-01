#!/usr/bin/env bash

NPROC=$(nproc)
echo "Number of Processors: $NPROC"
MEMORY=$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)
MEMORY=$(python -c "print('%.3fGB' % (int($MEMORY) / 1e9))")

echo "Total Memory: $MEMORY"
