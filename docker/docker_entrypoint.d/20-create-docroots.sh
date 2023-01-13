#!/bin/sh

#
# Mkdir all virtual host document roots with correct ownership
# 

VHOSTS_DIR=${APACHE_PREFIX}/conf.d/enabled_vhosts

len=$(echo -n ${APACHE_DOCROOT} | wc -m)

for vhost in "${VHOSTS_DIR}"/*.vhost; do
  if [ "$vhost" = "${VHOSTS_DIR}/*.vhost" ]; then
    echo "No virtual hosts enabled in ${VHOSTS_DIR}"
    exit 2
  fi
    
  docroot=$(sed -nE 's/[[:space:]]DocumentRoot[[:space:]]+(.*)/\1/p' "$vhost")
  docroot=$(eval "echo $docroot")

  if [ "$docroot" = "" ]; then
    echo "${vhost}: empty docroot skipping."
    continue
  fi

  prefix=$(echo "$docroot" | cut -c -"$len")
  if [ "$prefix" != "${APACHE_DOCROOT}" ]; then
    echo "$vhost: DocumentRoot not underneath ${APACHE_DOCROOT}: $docroot"
    exit 2
  fi
  
  mkdir -p "$docroot"
  chown "${APACHE_USER}:${APACHE_GROUP}" "$docroot"
  chmod o-rwx "$docroot"
done
