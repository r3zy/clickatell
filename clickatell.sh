#!/bin/bash
# Notify via api.clickatell.com

###===========###
##  Variables  ##
###===========###

USERNAME=""
PASSWORD=""
API_ID=""

DATE=`date +%Y-%m-%d`
NOW=`date +%Y-%m-%d_%H-%M`

NAME="clickatell-sms"
LOGFILE=/tmp/${NAME}_${DATE}.log

CURL="/usr/bin/curl"
HOSTSUBJECT="$NOTIFY_NOTIFICATIONTYPE $NOTIFY_HOSTALIAS"
SERVICESUBJECT="$NOTIFY_NOTIFICATIONTYPE $NOTIFY_HOSTALIAS $NOTIFY_SERVICEDESC"

# Debug
DEBUG=1                                 # 0=disable / 1=enable
#NOTIFY_CONTACTPAGER=""			# for testing
#HOSTSUBJECT="Testing"                  # for testing

###========###
##  Script  ##
###========###

### contactpager
if [[ -z $NOTIFY_CONTACTPAGER ]]; then
    if [ "$DEBUG" = "1" ]; then
        echo "$NOW - FAIL (no pagernumber)"  >> $LOGFILE
        exit 1
    else
        exit 1
    fi
fi

### service notification
if [ "$NOTIFY_WHAT" = "SERVICE" ]; then
    # without comment
    if [[ -z $NOTIFY_NOTIFICATIONCOMMENT ]]; then
        MESSAGE="$SERVICESUBJECT $NOTIFY_SERVICEOUTPUT"
    # with comment
    else
        MESSAGE="$SERVICESUBJECT <$NOTIFY_NOTIFICATIONCOMMENT> (by $NOTIFY_NOTIFICATIONAUTHOR) $NOTIFY_SERVICEOUTPUT"
    fi
### host notification
else
    # without comment
    if [[ -z $NOTIFY_NOTIFICATIONCOMMENT ]]; then
        MESSAGE="$HOSTSUBJECT $NOTIFY_HOSTOUTPUT"
    # with comment
     else
        MESSAGE="$HOSTSUBJECT <$NOTIFY_NOTIFICATIONCOMMENT> (by $NOTIFY_NOTIFICATIONAUTHOR) $NOTIFY_HOSTOUTPUT"
    fi
fi

if [ "$DEBUG" = "1" ]; then

env | grep NOTIFY_ | sort       >> $LOGFILE

echo "$NOW :: curl -G \
        --data-urlencode user=$USERNAME \
        --data-urlencode password=$PASSWORD \
        --data-urlencode api_id=$API_ID \
        --data-urlencode to=$NOTIFY_CONTACTPAGER \
        --data-urlencode text="$MESSAGE" \
      https://api.clickatell.com/http/sendmsg" >> $LOGFILE

fi

### send message

curl -G \
        --data-urlencode user=$USERNAME \
        --data-urlencode password=$PASSWORD \
        --data-urlencode api_id=$API_ID \
        --data-urlencode to=$NOTIFY_CONTACTPAGER \
        --data-urlencode text="$MESSAGE" \
      https://api.clickatell.com/http/sendmsg >> $LOGFILE
