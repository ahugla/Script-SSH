#!/bin/bash

#-----------------------------------------------------------------
#      VERSIONING
# v1.0 - 22 janvier 2019
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

echo "**************** NEW RUN ****************" >> isURLready.log
echo "nbre de retry (toutes les 2s): $maxRetry" >> isURLready.log
echo "URL = $URL" >> isURLready.log


continu=1
counter=1
while [ $continu -eq 1 ]
do
    echo "counter = $counter" >> isURLready.log

    #isWorking=1 si OK,
    isWorking=`curl -I $URL  | grep HTTP | grep OK | grep 200 | wc -l` 
    echo "isWorking = $isWorking" >> isURLready.log 

    if [ $isWorking -eq 1 ] || [ $counter -eq $maxRetry ]
    then
       continu=0
    else
       sleep 2
       counter=$((counter + 1))
    fi
done

