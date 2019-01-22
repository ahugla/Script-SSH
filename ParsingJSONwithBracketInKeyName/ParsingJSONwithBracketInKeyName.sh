#!/bin/bash


#-----------------------------------------------------------------
#      VERSIONING
# v1.0 - 22 janvier 2019
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#      DESCRIPTION
# Recupere un champ lorsque le JSON comporte une clé dont le nom
# contient des crochets []. Dans ce cas, ce n'est pas un Array.
# Exemple d'une clé problematique : payload.Machine[0].
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#      UTILISATION
# ./script.sh rootPath object indice field
#    avec : 
#      rootPath=deploymentDetails.resources
#      object=Cloud_Machine_1
#      position=0      =>  on prend Cloud_Machine_1[0]
#      field=address   =>  on prend Cloud_Machine_1[0].address
#      => deploymentDetails.resources."Cloud_Machine_1[0]".address
#-----------------------------------------------------------------

#-----------------------------------------------------------------
# PREREQUIS : INSTALL ON LINUX
# yum install epel-release -y
# yum install jq -y
#-----------------------------------------------------------------


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

# clean output
echo $output | sed -e 's/\"//g'
