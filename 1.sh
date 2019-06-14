#!/bin/bash
ZMPROV=/opt/zimbra/bin/zmprov
while read line
do
    $ZMPROV -l ga $line userPassword description sn zimbraLastLogonTimestamp
done < tmp.txt

