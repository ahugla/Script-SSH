#!/bin/bash

#-----------------------------------------------------------------
#      VERSIONING
# v1.0 - 19 fevrier 2019
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#      DESCRIPTION
# Envoie un message dans le channel shwrfr de slack
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#      UTILISATION
# ./script.sh MESSAGE
#-----------------------------------------------------------------


Message=$1
CONTENT_FILE="content_file"
logFile="sendToSlack.log"


cd /root/CAS_agent_scripts/sendToSlack


echo "**************** NEW RUN ****************" >> $logFile
date +"%d-%b-%y  -  %T" >> $logFile
echo "$Message" >> $logFile


# creation du fichier json de contenu
rm -f $CONTENT_FILE
echo "{\"text\":\"$Message\"}" >  $CONTENT_FILE


# envoi sur slack
curl -X POST -H 'Content-type: application/json' --data @$CONTENT_FILE  https://hooks.slack.com/services/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


rm -f $CONTENT_FILE
