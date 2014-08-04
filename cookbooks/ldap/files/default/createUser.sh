#!/bin/bash
sed '1,1d' benutzerdaten.csv > data.csv
INPUT=data.csv
OLDIFS=$IFS
IFS=","
PORT="389"
ROOTDN="cn=root"
PASSWD="psa2014"
LDIF="/tmp/createuser.ldif"
i="2000"
[ ! -f $INPUT ] &while read Name Vorname Geschlecht Geburtsdatum Geburtsort Nat Strasse PLZ Ort Telefon Matrikelnummer
do
	((i++))
        echo "dn: uid=$Name,ou=User,dc=team01,dc=psa,dc=rbg,dc?tum,dc=de" > $LDIF
        echo "cn: $Name $Vorname" >> $LDIF
        echo "uid: $Name" >> $LDIF
        echo "uidNumber: $i" >> $LDIF
        echo "gidNumber: $i" >> $LDIF
        echo "homeDirectory: /home/$Name" >> $LDIF
        echo "loginShell: /bin/bash" >> $LDIF
        echo "userPassword: $PASSWD" >> $LDIF
        echo "objectClass: top" >> $LDIF
        echo "objectClass: posixAccount" >> $LDIF

        echo "/usr/bin/ldapmodify -x -p $PORT -D "$ROOTDN" -w $PASSWD -a -f $LDIF"

done < $INPUT
IFS=$OLDIFS
