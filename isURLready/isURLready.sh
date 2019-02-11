#!/bin/bash

#-----------------------------------------------------------------
#      VERSIONING
# v1.1 - 30 janvier 2019
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#      DESCRIPTION
# Poll d'un server en curl et attente de la reponse un nbre de fois
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#      UTILISATION
# ./script.sh SERVER PORT MAXRETRY
#-----------------------------------------------------------------


Server=$1      # Server
Port=$2        # Port
maxRetry=$3    # nombre de fois qu'on attend 2 secondes avant de recommencer le test
URL="http://$Server:$Port"

logFile="isURLready.log"

echo "**************** NEW RUN ****************" >> $logFile
date +"%d-%b-%y  -  %T" >> $logFile
echo "nbre de retry (toutes les 2s): $maxRetry" >> $logFile
echo "URL = $URL" >> $logFile


continu=1
counter=1
while [ $continu -eq 1 ]
do
    #isWorking=1 si OK,
    isWorking=`curl --silent -I $URL  | grep HTTP | grep OK | grep 200 | wc -l` 
    echo "counter = $counter   -   isWorking = $isWorking" >> $logFile 

    if [ $isWorking -eq 1 ] || [ $counter -eq $maxRetry ]
    then
       continu=0
    else
       sleep 2
       counter=$((counter + 1))
    fi
done

#Return code
if [ $isWorking -eq 1 ]
then
    exit 0
else
    exit 1
fi






