#!/bin/bash
set -e

### several commands
echo "---> Copy commands  ..."
mv /tmp_install/commands /insaflu_web/ && chmod a+x /insaflu_web/commands/*

### set all default insaflu data
echo "--> set ownership <---"
chown -R ${APP_USER}:${APP_USER} /software && rm -rf /var/lib/apt/lists/*

## entry point
echo "---> Set entrypoint  ..."
cd / && mv /tmp_install/entrypoint.sh entrypoint_original.sh && sed "s/APP_USER/${APP_USER}/g" entrypoint_original.sh > entrypoint.sh && rm entrypoint_original.sh && chmod a+x entrypoint.sh

echo "---> Delete temporary files  ..."
## delete the temporary folder
rm -R -f /tmp_install/

