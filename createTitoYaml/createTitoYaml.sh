#!/bin/bash

#-----------------------------------------------------------------
#      VERSIONING
# v1.1 - 21 fevrier 2019
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#      DESCRIPTION
# Creation d'un fichier YAML pour tito (RC, Service et pods)
# Puis depo sur Gihub dans: .../Demo-Tito/CodeStreamDemo.yaml
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
date +"%d-%b-%y  -  %T" >> $logFile
echo "yamlVersion = $yamlVersion" >> $logFile
echo "nodePort = $nodePort" >> $logFile
echo "Proxy_Name = $Proxy_Name" >> $logFile
echo "Proxy_Port = $Proxy_Port" >> $logFile


cd /root/Demo-Tito


# download le template yaml de tito
rm -f $titoYamlFile
curl --silent -O https://raw.githubusercontent.com/ahugla/Demo-Tito/master/$titoYamlFile


# modification du fichier template
sed -i -e 's/value: V1.9.2/value: '"$yamlVersion"'/g' $titoYamlFile
sed -i -e 's/31200/'"$nodePort"'/g' $titoYamlFile
sed -i -e 's/wvfp1.cpod-vr.shwrfr.mooo.com/'"$Proxy_Name"'/g' $titoYamlFile
sed -i -e 's/2878/'"$Proxy_Port"'/g' $titoYamlFile


# Rename du fichier template
rm -f CodeStreamDemo.yaml
mv $titoYamlFile CodeStreamDemo.yaml


# git sync
git pull https://github.com/ahugla/Demo-Tito.git master > /dev/null 2>&1
git add -A  > /dev/null 2>&1
git commit -m "Code Stream Demo" > /dev/null 2>&1
git push  https://github.com/ahugla/Demo-Tito.git > /dev/null 2>&1


#echo "Completed !" >> $logFile

