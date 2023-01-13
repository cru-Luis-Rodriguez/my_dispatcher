#!/bin/sh
set -e

[ $(curl -m 5 -s -H "X-AEM-LIVENESS-PROBE: Readiness-Probe" -w "%{http_code}\\n" "http://${AEM_HOST}:${AEM_PORT}/systemready" -o /dev/null || true) -eq 200 ]
