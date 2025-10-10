#!/bin/bash

docker run -d -it \
--name dynamo_sglang_mx_ll \
--shm-size 32g \
--ipc=host   \
--privileged  \
--network=host  \
-v /mnt/data0:/mnt/nfs \
-v /opt/mxdriver:/opt/mxdriver  \
-v /dev/infiniband:/dev/infiniband  \
-v /dev/mxcd:/dev/mxcd  \
-v /dev/shm:/dev/shm  \
-v /root/.vscode-server:/root/.vscode-server  \
-v /root/.ssh:/root/.ssh  \
10.200.93.79:15080/metax/dynamo-sglang/dynamo_sglang_mx:v0.3
