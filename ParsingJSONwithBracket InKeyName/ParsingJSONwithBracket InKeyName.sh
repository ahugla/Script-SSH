#!/bin/bash

# INSTALL ON LINUX
# yum install epel-release -y
# yum install jq -y
# jq --version


rootPath=deploymentDetails.resources
object=Cloud_Machine_1
position=0
field=address


# more file.json | jq .deploymentDetails.resources.\"Cloud_Machine_1[0]\".address
# more file.json | jq ."$rootPath".\"Cloud_Machine_1[0]\"."$field"
# more file.json | jq ."$rootPath".\""$object"[0]\"."$field"

more file.json | jq ."$rootPath".\""$object"["$position"]\"."$field"

