#!/bin/sh

#
# Generate allowed clients for dispatcher
#
mkdir -p ${APACHE_PREFIX}/conf.dispatcher.d/cache
OUTPUT_FILE=${APACHE_PREFIX}/conf.dispatcher.d/cache/default_invalidate.any

#
# This script is run *after* AEM_HOST is available so we don't need
# to wait for its availability
#
AEM_IPS=$(getent ahosts "${AEM_HOST}" | cut -f1 -d' ' | sort -u)

cat << EOF > ${OUTPUT_FILE}
# Generated by docker entrypoint script, manual changes will be lost
/0001 {
  /type "deny"
  /glob "*.*.*.*"
}
EOF

i=2

for ip in ${AEM_IPS}
do
  printf "/%04d {\n" $i >> ${OUTPUT_FILE}
  echo "  /type \"allow\"" >> ${OUTPUT_FILE}
  echo "  /glob \"$ip\"" >> ${OUTPUT_FILE}
  echo "}" >> ${OUTPUT_FILE}
  i=$(expr $i + 1)
done