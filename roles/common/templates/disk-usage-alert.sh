#!/bin/bash
# set -x

# {{ ansible_managed }}

# Shell script to monitor or watch the disk space
# It will send an email to $EMAIL when the (free available) percentage of space is >= 80%.
# -------------------------------------------------------------------------

EMAIL="{{ notify_email }}"
USE_ALERT_PCT=80

# Exclude list of unwanted monitoring, if several partions then use "|" to separate the partitions.
# An example: EXCLUDE_LIST="/dev/sda1|/dev/sda5"
EXCLUDE_LIST=""

function do_mail() {
while read output;
do
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)
  partition=$(echo $output | awk '{print $2}')
  if [ $usep -ge $USE_ALERT_PCT ] ; then
     echo "Running out of space: $partition is $usep% used on server $(hostname)." | \
     mail -s "WARNING: $(hostname) running out of disk space: $usep% used" $EMAIL
  fi
done
}

if [ "$EXCLUDE_LIST" != "" ] ; then
  df -H | grep -vE "^Filesystem|tmpfs|cdrom|${EXCLUDE_LIST}" | awk '{print $5 " " $6}' | do_mail
else
  df -H | grep -vE "^Filesystem|tmpfs|cdrom" | awk '{print $5 " " $6}' | do_mail
fi