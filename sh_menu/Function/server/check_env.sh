#!/bin/bash

docker images | grep 0.5.1

ls /mnt/data0/ll/ | grep shell_main

ls /mnt/data2/ | grep Kimi-K2-instruct-bf16

mx-smi --show-process