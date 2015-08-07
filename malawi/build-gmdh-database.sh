#!/bin/bash

# set -x
# trap read debug

LOGFILE=`pwd`/$$.log
exec > $LOGFILE 2>&1

USERNAME=openboxes
PASSWORD=openboxes
DATABASE=openboxes

echo Setting environment variables
#if [ -f setenv.sh ]; then
#  echo Setting custom environment variables
#  . setenv.sh
#fi
cd /home/backups/bin/openboxes-gmdh/malawi
source setenv.sh

echo "Executing GMDH SQL updates against database $DATABASE as user $USERNAME"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source location-classification.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source update-location-classifications.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source leadtimes.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source create-function-get-tags.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source transaction-report-vw.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source latest-inventory-snapshot.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source reorder-point-vw.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source shipment-status.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source pending-orders-vw.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source leadtime-summary-vw.sql;"
mysql --user="$USERNAME" --password="$PASSWORD" --database="$DATABASE" --execute="source inventory-query-debug-vw.sql;"


echo Send email to admins

MAIL=jcm62@columbia.edu
TODAY=`date +%Y%m%d`
mailx -s "Malawitest Refresh: Successfully executed nightly GMDH scripts $TODAY" "$MAIL" < $LOGFILE
#rm $LOGFILE
