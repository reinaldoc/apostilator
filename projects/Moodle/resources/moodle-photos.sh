#!/bin/bash
# moodle-photos.sh - A script to create a Zip file to be loaded by Moodle
# to update users profile photo from LDAP photo attribute.
#
# Writed by reinaldoc

LDAP_HOST=''
LDAP_BASE=''
LDAP_BIND_USER=''
LDAP_BIND_PASS=''
LDAP_USERNAME_ATTR=samAccountName
LDAP_PHOTO_ATTR=photo

# init
test -x "$(which ldapsearch)" || { echo 'ldapsearch command not found.' && exit; }
test -f moodle-users.csv || { echo 'moodle-users.csv not found.' && exit; }
rm -rf moodle-photo.zip >/dev/null 2>&1

# create a work directory
mkdir -p data || { echo 'cant create ./data work directory' && exit; }

cd data

# load users from CSV second field
while read username ; do

    # get photo from ldap and save to temp file
    img_file=$(ldapsearch -x -LLL -h "${LDAP_HOST}" -D "${LDAP_BIND_USER}" -w "${LDAP_BIND_PASS}" -b "${LDAP_BASE}" -t "${LDAP_USERNAME_ATTR}=${username}" "${LDAP_PHOTO_ATTR}" | grep "${LDAP_PHOTO_ATTR}": | cut -f3- -d /)

    # rename temporary file to username.jpg on work dir
    mv "${img_file}" "${username}.jpg"

done < <(cut -f2 -d, ../moodle-users.csv | sed -e '1d')

# change file permissions
cd ../
chmod 644 data/*

# build a zip file
cd data
zip -r ../moodle-photo.zip .
zip --test ../moodle-photo.zip

# remove work directory
cd ../
rm -rf data

