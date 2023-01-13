#!/bin/sh

if [ -z "${DISP_LOG_LEVEL}" ]; then
  DISP_LOG_LEVEL=Warn
else
  case "${DISP_LOG_LEVEL}" in
    [Tt]race1 | [Dd]ebug | [Ii]nfo | [Ww]arn | [Ee]rror)
      ;;
    *)
      echo "Dispatcher log level defined unknown: ${DISP_LOG_LEVEL}"
      exit 2
      ;;
  esac
  echo "Detected dispatcher log level: ${DISP_LOG_LEVEL}"
fi

if [ -z "${REWRITE_LOG_LEVEL}" ]; then
  REWRITE_LOG_LEVEL=Warn
else
  case "${REWRITE_LOG_LEVEL}" in
    [Tt]race[1-8] | [Dd]ebug | [Ii]nfo | [Ww]arn | [Ee]rror)
      ;;
    *)
      echo "Rewrite log level defined unknown: ${REWRITE_LOG_LEVEL}"
      exit 2
      ;;
  esac
  echo "Detected rewrite log level: ${REWRITE_LOG_LEVEL}"
fi

cat >> /usr/sbin/envvars <<EOF
export DISP_LOG_LEVEL="${DISP_LOG_LEVEL}"
export REWRITE_LOG_LEVEL="${REWRITE_LOG_LEVEL}"
EOF