#!/bin/bash

#-----------------------------------------------------------------
#      VERSIONING
# v1.0 - 30 janvier 2019
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#      DESCRIPTION
# Creartion d'un fichier YAML pour tito (RC, Service et pods)
# Puis depo sur Gihub : K8S_yaml/TITO/NodePort/CodeStreamDemo/CodeStreamDemo.yaml
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#      UTILISATION
# ./script.sh TITOVERSION NODEPORT WAVEFRONTPROXY WAVEFRONTPROXYPORT
#-----------------------------------------------------------------


titoYamlFile=tito_svc_rc_Template.yaml
yamlVersion=$1
nodePort=$2
Proxy_Name=$3
Proxy_Port=$4
logFile=createTitoYaml.log

echo "**************** NEW RUN ****************" >> $logFile
echo "yamlVersion = $yamlVersion" >> $logFile
echo "nodePort = $nodePort" >> $logFile
echo "Proxy_Name = $Proxy_Name" >> $logFile
echo "Proxy_Port = $Proxy_Port" >> $logFile


cd /root/CAS_agent_scripts/createTitoYaml


# download le template yaml de tito
rm -f $titoYamlFile
curl --silent -O https://raw.githubusercontent.com/ahugla/K8S_yaml/master/TITO/NodePort/$titoYamlFile


# modification du fichier
sed -i -e 's/value: V1.9.2/value: '"$yamlVersion"'/g' $titoYamlFile
sed -i -e 's/31200/'"$nodePort"'/g' $titoYamlFile
sed -i -e 's/wvfp1.cpod-vr.shwrfr.mooo.com/'"$Proxy_Name"'/g' $titoYamlFile
sed -i -e 's/2878/'"$Proxy_Port"'/g' $titoYamlFile


# on deplace le fichier yaml au bon endroit sur le depot
rm -f github_K8S_yaml/TITO/NodePort/CodeStreamDemo/CodeStreamDemo.yaml
mv $titoYamlFile github_K8S_yaml/TITO/NodePort/CodeStreamDemo/CodeStreamDemo.yaml


# git sync
cd ./github_K8S_yaml
git add -A
git commit -m "Code Stream Demo"
git push  https://github.com/ahugla/K8S_yaml.git


#echo "Completed !" >> $logFile

