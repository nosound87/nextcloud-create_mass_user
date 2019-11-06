#!/bin/bash
 
IMPORTF='/var/lib/nginx/*.csv' 		# path your .csv file
CONV_PL='/var/lib/nginx/convert.csv' 	
CSV='/var/lib/nginx/data.csv'
PWGEN=`/bin/pwgen -N 1 -s 16`
TEMP_PASS=`echo \"$PWGEN\"`
PHP='/usr/bin/php'
OCC='/var/www/html/nextcloud/occ' 	# path to the 'occ' script file
COUNTER=`cat $CSV | tail -n +2 | wc -l`
GROUP='SOME_GROUP'  			# set the name of the group
 
#Checking .csv file and adding special char to eof.
if [ ! -e $CSV ]; then
        /bin/iconv -f cp1250 -t utf8 -o $CONV_PL $IMPORTF
        /bin/dos2unix -q $CONV_PL
        cat $CONV_PL | sed -e 's/$/;/g' > $CSV
fi
 
#Decalre empty arrays to collect data user from csv
ARRAY_FIRSTNAME=()
ARRAY_LASTNAME=()
ARRAY_EMAIL=()
 
#OCC - user parameters
FIRSTNAME=$(for i in $COUNTER; do cat $CSV | tail -n +2 | awk -F';' '{print $1}'; done)
LASTNAME=$(for i in $COUNTER; do cat $CSV | tail -n +2 | awk -F';' '{print $2}'; done)
EMAIL=$(for i in $COUNTER; do cat $CSV | tail -n +2 | awk -F';' '{print $3}'; done)
 
#Export temporary password require variable
export OC_PASS=$TEMP_PASS
 
#Separate data and adding to arrays
for i in $FIRSTNAME; do ARRAY_FIRSTNAME+=($i); done
for i in $LASTNAME; do ARRAY_LASTNAME+=($i); done
for i in $EMAIL; do ARRAY_EMAIL+=($i); done
 
#Creating new user
for ((i=0;i<${#ARRAY_FIRSTNAME[@]};i++))
do
        $PHP $OCC user:add "${ARRAY_EMAIL[i]}" --password-from-env --group="$GROUP" --display-name="${ARRAY_FIRSTNAME[i]} ${ARRAY_LASTNAME[i]}"
        $PHP $OCC user:setting "${ARRAY_EMAIL[i]}" settings email "${ARRAY_EMAIL[i]}"
done
 
#ending...
/bin/rm -fr $CONV_PL $CSV
 
exit 0

