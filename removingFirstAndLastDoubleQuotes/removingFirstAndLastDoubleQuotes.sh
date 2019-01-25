#!/bin/bash


#-----------------------------------------------------------------
#      VERSIONING
# v1.0 - 25 janvier 2019
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#      DESCRIPTION
# retrait d'une " au debut et a la fin
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#      UTILISATION
# ./script.sh STRING
#-----------------------------------------------------------------


echo "**************** NEW RUN ****************" >> removingFirstAndLastDoubleQuotes.log
echo "chaine d'input : $1" >> removingFirstAndLastDoubleQuotes.log

longueur=`echo $1 | wc -m`
#echo "longueur = $longueur"
end=$(( $longueur - 2 ))

#on recupere l'input sans les doubles quotes au debut et a la fin
cleanInput=`echo $1 | cut -c 2-$end`
echo "chaine sans double quotes = $cleanInput"  >>  removingFirstAndLastDoubleQuotes.log

echo $cleanInput



