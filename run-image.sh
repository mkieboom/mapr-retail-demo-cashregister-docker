#!/bin/bash

docker run -it \
-e MAPR_IP=172.16.4.247 \
-p 80:80 \
mkieboom/mapr-retail-demo-cashregister-docker bash
