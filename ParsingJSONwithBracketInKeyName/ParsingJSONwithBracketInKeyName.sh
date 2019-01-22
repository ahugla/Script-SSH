#!/bin/bash

# PREREQUIS : INSTALL ON LINUX
# yum install epel-release -y
# yum install jq -y



#rootPath=deploymentDetails.resources
#object=Cloud_Machine_1
#position=0
#field=address
rootPath=$1
object=$2
indice=$3
field=$4
echo "rootPath = $rootPath" >>ParsingJSONwithBracketInKeyName.log
echo "object = $object" >>ParsingJSONwithBracketInKeyName.log
echo "indice = $indice" >>ParsingJSONwithBracketInKeyName.log
echo "field = $field" >>ParsingJSONwithBracketInKeyName.log



# more file.json | jq .deploymentDetails.resources.\"Cloud_Machine_1[0]\".address
# more file.json | jq ."$rootPath".\"Cloud_Machine_1[0]\"."$field"
# more file.json | jq ."$rootPath".\""$object"[0]\"."$field"
output=`more file.json | jq ."$rootPath".\""$object"["$indice"]\"."$field"`
echo "output = $output"



